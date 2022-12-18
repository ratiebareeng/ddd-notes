import 'package:ddd_notes/injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DDD Notes App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DDD Notes'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
