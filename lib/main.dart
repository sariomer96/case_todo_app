import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spexco_todo_app/repository/task_repository.dart';
import 'package:spexco_todo_app/view/home/home_page/home_page.dart';
import 'package:spexco_todo_app/view/home/view_model/home_view_model.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/task_form_page.dart';
import 'package:spexco_todo_app/view/task_detail/view_model/task_form_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskFormViewModel(TaskRepository())),
        ChangeNotifierProvider(create: (_) => HomeViewModel(TaskRepository())),
     
      ],
      child: const MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: { 
          '/': (context) => const HomePage(),
       
      },
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
  
    );
  }
}
