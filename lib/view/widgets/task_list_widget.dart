import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/view/home/home_page/home_page.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/edit_task_view_model.dart';
import 'package:spexco_todo_app/view/widgets/task_form_bottom_sheet.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().getAllTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final editViewModel = context.watch<EditTaskViewModel>();
    final tasksToShow =
        viewModel.tasks.isEmpty ? viewModel.allTasks : viewModel.tasks;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: tasksToShow.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Başlamak için görev ekle',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+ butonuna tıkla!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: viewModel.tasks.isEmpty
                    ? viewModel.allTasks.length
                    : viewModel.tasks.length,
                itemBuilder: (context, index) {
                  final task = viewModel.tasks.isEmpty
                      ? viewModel.allTasks[index]
                      : viewModel.tasks[index];

                  var date = task.lastDate;
                  DateTime dateTime = DateTime.parse(date);
                  return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.padding * 2.25),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        if (task.id != null) {
                          await context
                              .read<HomeViewModel>()
                              .removeTask(task.id!);
                          setState(() {
                            viewModel.tasks.removeAt(index);
                          });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${task.taskName} Silindi',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ListTile(
                          onTap: () {
                            final editViewModel =
                                context.read<EditTaskViewModel>();
                            editViewModel.setTask(task);

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => TaskFormBottomSheet(
                                task: task,
                                selectedFormPage: TaskPageEnum.editForm,
                              ),
                            );
                          },
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: task.isFinished,
                                onChanged: (value) async {
                                  setState(() {
                                    task.isFinished = value ?? false;
                                  });
                                  if (task.id != null) {
                                    await editViewModel.editTask(task);
                                    if (task.isFinished) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Görev başarıyla tamamlandı',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              task.isFinished
                                  ? const Icon(Icons.flag, color: Colors.green)
                                  : const Icon(Icons.flag_outlined),
                            ],
                          ),
                          title: Text(task.taskName),
                          trailing: Text(
                            task.lastDate != null
                                ? '${dateTime.day}'
                                    '/'
                                    '${dateTime.month}'
                                    '/'
                                    '${dateTime.year}'
                                : '',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ));
                },
              ),
      ),
    );
  }
}
