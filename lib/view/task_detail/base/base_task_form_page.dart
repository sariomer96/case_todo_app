import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/base_task_view_model.dart';

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
   

    _nameController =
        TextEditingController(text: widget.task?.taskName ?? "");
    _commentController =
        TextEditingController(text: widget.task?.taskComment ?? "");

     WidgetsBinding.instance.addPostFrameCallback((_) {
    final vm = context.read<T>();

    if (widget.task == null) {
     
      vm.setDate(null);                   
      vm.setCategory("Varsayılan");      
      vm.setPriority("Düşük");            
    } else {
   
      vm.setDate(widget.task!.lastDate != null
          ? DateTime.tryParse(widget.task!.lastDate!)
          : null);
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
          padding: const EdgeInsets.all(16),
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
                maxLines: 5,
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
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: vm.selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) vm.setDate(pickedDate);
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  vm.selectedDate != null
                      ? "Seçilen Tarih: ${vm.selectedDate!.day}/${vm.selectedDate!.month}/${vm.selectedDate!.year}"
                      : "Bitiş Tarihi",
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
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
