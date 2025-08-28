import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';

import 'package:spexco_todo_app/view/home/home_page/home_page.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/add_task/add_task_view_model/add_task_view_model.dart';
import 'package:spexco_todo_app/view/edit_task/edit_task_view_model/edit_task_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeViewModel(TaskRepository())),
        ChangeNotifierProvider(
            create: (_) => AddTaskViewModel(TaskRepository())),
        ChangeNotifierProvider(
            create: (_) => EditTaskViewModel(TaskRepository())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spexco Todo App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
    );
  }
}
