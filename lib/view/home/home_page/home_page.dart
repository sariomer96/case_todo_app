import 'package:flutter/material.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/task_add_page.dart';

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
             builder: (BuildContext context) {
        return DraggableScrollableSheet(
       initialChildSize: 0.5, 
      minChildSize: 0.25,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: const AddPage()
          ),
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
  List<String> tasks = List.generate(5, (index) => 'Görev ${index + 1}');
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(tasks[index]),
              
            );
          },
        ),
      ),
    );
  }
}








class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Click here to try the Modal Bottom Sheet ',
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                 
                },
                child: const Text("Click here"))
          ],
        ),
      ),
    );
  }
}