import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/base_task_detail/base_view_model/base_task_view_model.dart';

class BaseTaskFormWidget<T extends BaseTaskViewModel> extends StatefulWidget {
  final String buttonText;
  final Task? task;
  final Future<bool> Function(T vm, Task task) onSubmit;

  const BaseTaskFormWidget({
    super.key,
    required this.buttonText,
    required this.onSubmit,
    this.task,
  });

  @override
  State<BaseTaskFormWidget<T>> createState() => _BaseTaskFormWidgetState<T>();
}

class _BaseTaskFormWidgetState<T extends BaseTaskViewModel>
    extends State<BaseTaskFormWidget<T>> {
  late TextEditingController _nameController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.task?.taskName ?? "");
    _commentController =
        TextEditingController(text: widget.task?.taskComment ?? "");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<T>();

      if (widget.task == null) {
        vm.setDate(DateTime.now());
        vm.setCategory("Varsayılan");
        vm.setPriority("Düşük");
      } else {
        final date = DateTime.tryParse(widget.task!.lastDate);
        if (date != null) vm.setDate(date);
        vm.setCategory(widget.task!.category ?? "Varsayılan");
        vm.setPriority(widget.task!.priority ?? "Düşük");
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, vm, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.padding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Görev Adı"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: "Açıklama"),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text("Kategori"),
              Wrap(
                spacing: 8,
                children: Constants.categories.map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: vm.selectedCategory == cat,
                    onSelected: (_) => vm.setCategory(cat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text("Öncelik"),
              Wrap(
                spacing: 8,
                children: Constants.priorityLevels.map((p) {
                  final color = Constants.priorityColors[p] ?? Colors.grey;
                  return ChoiceChip(
                    label: Text(p),
                    selected: vm.selectedPriority == p,
                    selectedColor: color.withOpacity(0.5),
                    onSelected: (_) => vm.setPriority(p),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

         
              ElevatedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  final initial = vm.selectedDate ?? today;
                  final safeInitial =
                      initial.isBefore(today) ? today : initial;

                  final pickedDate = await showDatePicker(
                  
                    context: context,
                    initialDate: safeInitial,
                    firstDate: today, 
                    lastDate: DateTime(2100),

                    selectableDayPredicate: (DateTime d) {
                      final dd = DateTime(d.year, d.month, d.day);
                      return !dd.isBefore(today);
                    },

                    builder: (context, child) {
                  
                      const seed = Colors.grey;

                      final theme = Theme.of(context);
                      final scheme = ColorScheme.fromSeed(seedColor: seed);

                      return Theme(
                        data: theme.copyWith(
                          colorScheme: scheme,
                          datePickerTheme: DatePickerThemeData(
                            backgroundColor: scheme.surface,
                            headerBackgroundColor: scheme.primary,
                            headerForegroundColor: scheme.onPrimary,
                            surfaceTintColor: Colors.transparent,
                            todayForegroundColor:
                                WidgetStatePropertyAll(scheme.primary),
                            todayBackgroundColor: WidgetStatePropertyAll(
                              scheme.primary.withOpacity(0.15),
                            ),
                            dayForegroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return scheme.onPrimary;
                              }
                              return null;
                            }),
                            dayBackgroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return scheme.primary;
                              }
                              return null;
                            }),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: scheme.primary,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    vm.setDate(pickedDate);
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  vm.selectedDate != null
                      ? "Bitiş Tarihi: ${vm.selectedDate.day}/${vm.selectedDate.month}/${vm.selectedDate.year}"
                      : "Bitiş Tarihi",
                ),
              ),
              // ======= /TARİH SEÇİCİ =======

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          if (_nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Görev adı boş bırakılamaz. Lütfen eksik alanları doldurunuz.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final task = vm.createModel(
                            _nameController.text,
                            _commentController.text,
                            id: widget.task?.id,
                          );

                          final success = await widget.onSubmit(vm, task);
                          if (success && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                  child: vm.isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
