import 'package:cat_dog/camera/camera_viewer.dart';
import 'package:cat_dog/camera/capture_button.dart';
import 'package:cat_dog/camera/top_image_viewer.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        CameraViewer(),
        CaptureButton(),
        TopImageViewer()
      ],
    );
  }
}
