import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/data/Models/task_model.dart';
import 'package:spexco_todo_app/data/Sqlite/db_manager.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/add_task_page.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/edit_task_page.dart';

import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart'; 

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
  
  return Scaffold(
    appBar: AppBar(
      title: const Text('Todo'),
    ),
    body: Column(
      children: [
        _searchFilter(),
        const TaskListView(),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
            final taskViewModel = context.read<TaskFormViewModel>();
          taskViewModel.setTask(null);  
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const TaskFormBottomSheet(selectedFormPage: TaskPageEnum.addForm),
          );
        },

      child: const Icon(Icons.add),
    ),
  );
}

    
  Row _searchFilter() {
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
          onPressed: () {},
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
    final taskViewModel = context.watch<TaskFormViewModel>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: viewModel.tasks.length,
          
          itemBuilder: (context, index) {
            final task = viewModel.tasks[index];
        
            return Dismissible(
              key: ValueKey(task.id),  
              direction: DismissDirection.endToStart,  
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {

                  if (task.id != null) { 
                    context.read<HomeViewModel>().removeTask(task.id!);
                  }
            
                setState(() {
                  viewModel.tasks.removeAt(index);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    
                  SnackBar(content: Text('${task.taskName} Silindi',textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge),
                  backgroundColor: Colors.red,),
                  
                );
                
              },
              child: ListTile(
                onTap: () {   
                   final taskViewModel = context.read<TaskFormViewModel>();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    taskViewModel.setTask(task); 
                    
              });
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const TaskFormBottomSheet(selectedFormPage: TaskPageEnum.editForm),
                  );

                },
                leading: Row(
                   mainAxisSize: MainAxisSize.min,
                  children: [
                        Checkbox(
                    value: task.isFinished,
                    onChanged: (value) async{
                      setState(() {
                        task.isFinished = value ?? false;
                      });
                      if (task.id != null) {
                          await taskViewModel.editTask(task);
                          if(task.isFinished) { 
                       ScaffoldMessenger.of(context).showSnackBar(
                        
                      SnackBar(content: Text('${task.taskName} Tamamlandi'
                      ,textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                      backgroundColor: Colors.green,),
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
  const TaskFormBottomSheet({super.key, this.task, required this.selectedFormPage});

  @override
  Widget build(BuildContext context) {
     
      Widget content;
        switch (selectedFormPage) {
          case TaskPageEnum.addForm:
            content =  const AddTaskPage();
            break;
          case TaskPageEnum.editForm:
            content = const EditTaskPage();
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
          child: content
        );
      },
    );
  }
}
