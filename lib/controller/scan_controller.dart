import 'dart:ffi';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ScanController extends GetxController{
  late Interpreter interpreter;
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraImage cameraImage;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
          cameras[0],
          ResolutionPreset.max
      );

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 100 == 0){
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });

      isCameraInitialized(true);
      update();
    }else{
      print("Permission denied");
    }
  }

  initTFLite() async{
    interpreter = await Interpreter.fromAsset('assets/mobilenet.tflite');
  }

  objectDetector(CameraImage image) async {
    img.Image capture = img.Image.fromBytes(
        image.width,
        image.height,
        image.planes[0].bytes,
        format: img.Format.rgba
    );

    Uint8List jpeg = Uint8List.fromList(img.encodeJpg(capture));
    print(jpeg.length);
    print("image captured!");
  }

}