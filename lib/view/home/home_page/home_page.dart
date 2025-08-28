import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/Constants/constants.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/data/Sqlite/db_manager.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/add_task_page.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/edit_task_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/add_task_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/edit_task_view_model.dart';
 

enum TaskPageEnum {
  addForm,
  editForm,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    
  @override
  Widget build(BuildContext context) {
     var viewModel = context.read<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Column(
        children: [
          
          _searchFilter(viewModel),
          const TaskListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const TaskFormBottomSheet( 
                selectedFormPage: TaskPageEnum.addForm),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openFilterSheet(BuildContext context,HomeViewModel viewModel) {
       
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: "Filter",
            pageBuilder: (context, anim1, anim2) {
              return Align(
                alignment: Alignment.centerRight,
                child: Material(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75, 
                    height: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: const Text("Filtrele"),
                          automaticallyImplyLeading: false,
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                                Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                       const Text(
                                    "Kategori",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                 Selector<HomeViewModel, String?>(
                                      selector: (context, vm) => vm.selectedCategory,
                                      builder: (context, selectedCategory, child) {
                                        return Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: Constants.categories.map((cat) {
                                            return ChoiceChip(
                                              showCheckmark: true,
                                              label: Text(cat),
                                              selected: selectedCategory == cat,
                                              onSelected: (selected) {
                                                final viewModel = Provider.of<HomeViewModel>(context, listen: false);
                                                viewModel.setCategory(cat);
                                              },
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  const SizedBox(height: 24),  
                          
                                  const Text(
                                    "Öncelik",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Selector<HomeViewModel, String?>(
                                     selector: (context, vm) => vm.selectedPriority,
                                      builder: (context, selectedPriority, child) {
                                        return Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: Constants.priorityColors.keys.map((priority) {
                                        return ChoiceChip(
                                          showCheckmark: true,
                                          label: Text(priority),
                                          labelStyle: TextStyle(
                                            color: Constants.priorityColors[priority],
                                          ),
                                          selected: viewModel.selectedPriority == priority,
                                          selectedColor:
                                              Constants.priorityColors[priority]?.withOpacity(0.2),
                                          onSelected: (selected) {
                                                    
                                               viewModel.setPriority(priority);  
                                             
                                          },
                                        );
                                      }).toList(),
                                    );}
                                  ),

                                  TextButton(onPressed: () {
                                      viewModel.setPriority('');
                                      viewModel.setCategory('');
                                  }, child: const Text('Filtre Temizle')),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(onPressed: () async {
                                      /// search filter
                                      await viewModel.filterByCategoryWithPriority();
                                      Navigator.pop(context);
                                    }, child: 
                                    const Text('Listele',)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Row _searchFilter(HomeViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _openFilterSheet(context, viewModel),
        ),
      ],
    );
  }
}

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
 
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: viewModel.tasks.isEmpty ? 
          viewModel.allTasks.length : viewModel.tasks.length,
          itemBuilder: (context, index) {
             final task = viewModel.tasks.isEmpty
                        ? viewModel.allTasks[index]
                        : viewModel.tasks[index];

            return Dismissible(
              key: ValueKey(task.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                if (task.id != null) {
                  await context.read<HomeViewModel>().removeTask(task.id!);
                  setState(() {
                  viewModel.tasks.removeAt(index);
                });
                }

                

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${task.taskName} Silindi',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: ListTile(
              onTap: () {
                  final editViewModel = context.read<EditTaskViewModel>();
           
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${task.taskName} Tamamlandı',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                  ],
                ),
                title: Text(task.taskName),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskFormBottomSheet extends StatelessWidget {
  final Task? task;
  final TaskPageEnum selectedFormPage;
  const TaskFormBottomSheet(
      {super.key, this.task, required this.selectedFormPage});

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (selectedFormPage) {
      case TaskPageEnum.addForm:
        content = const AddTaskPage();
        break;
      case TaskPageEnum.editForm:
            if (task != null) { 
              content =  EditTaskPage(task: task!);
            } else { 
              throw Exception('Task null error');
            } 
        break;
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.25,
      maxChildSize: 0.75,
      expand: false,
      builder: (context, scrollController) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: content);
      },
    );
  }
}
