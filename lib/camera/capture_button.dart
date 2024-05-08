import 'package:cat_dog/controller/scan_controller2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaptureButton extends GetView<ScanController2> {
  const CaptureButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      child: GestureDetector(
        onTap: () => controller.capture(),
        child: Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white60, width: 5),
            shape: BoxShape.circle
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
            child: Center(
              child: Icon(Icons.camera, size: 60),
            ),
          ),
        ),
      )
    );
  }
}
