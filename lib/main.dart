import 'package:flutter/material.dart';
import 'widget/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(0, 45, 45, 46),
      ),
      home: const GroceryList(),
    );
  }
}
