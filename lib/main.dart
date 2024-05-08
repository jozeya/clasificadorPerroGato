import 'package:cat_dog/camera/camera_screen.dart';
import 'package:cat_dog/global_bindings.dart';
import 'package:cat_dog/views/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
      title: "Cat dog",
      initialBinding: GlobalBindings(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Cat Dog',
  //     theme: ThemeData(
  //         primarySwatch: Colors.blue
  //     ),
  //     home: const CameraView(),
  //   );
  // }
}
