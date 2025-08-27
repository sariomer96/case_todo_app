import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/data/Sqlite/db_manager.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/task_form_page.dart';

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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
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
            child: const TaskFormPage(),
          );
        },
      );
    },
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
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
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
