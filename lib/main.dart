import 'package:flutter/material.dart';
import 'package:spexco_todo_app/view/home/home_page/home_page.dart';
import 'package:spexco_todo_app/view/task_detail/task_page/task_add_page.dart';

void main() {
  runApp(const MyApp());
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
