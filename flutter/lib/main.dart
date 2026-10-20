import 'package:flutter/material.dart';
import 'login.dart'; // Шинэ нэвтрэх хуудсаа холбож өгнө

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Market Auth',
      debugShowCheckedModeBanner: false,
      
      home: const SchoolLoginScreen(), 
    );
  }
}
