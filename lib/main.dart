import 'package:cat_dog/views/camera_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Dog',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: const CameraView(),
    );
  }
}
