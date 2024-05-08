import 'package:camera/camera.dart';
import 'package:cat_dog/controller/scan_controller2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CameraViewer extends StatelessWidget {
  const CameraViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController2>(builder: (controller){
      if (!controller.isInitialized){
        return Container();
      }
      return SizedBox(
          height: Get.height,
          width: Get.width,
          child: CameraPreview(controller.cameraController)
      );
    });
  }
}
