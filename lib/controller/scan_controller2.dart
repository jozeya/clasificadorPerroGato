import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ScanController2 extends GetxController {

  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late CameraImage _cameraImage;
  final RxList<Uint8List> _imageList = RxList([]);
  var cameraCount = 0;
  late Interpreter interpreter;

  List<Uint8List> get imageList => _imageList;
  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _isInitialized.value = true;
      _cameraController.startImageStream((image) {
        cameraCount++;
        if (cameraCount % 100 == 0){
          _cameraImage = image;
          cameraCount = 0;
          capture();
        }
        update();
      });
    }).catchError((Object e){
      if (e is CameraException){
        switch (e.code){
          case 'CameraAccessDenied':
            print("User denied camera access");
            break;
          default:
            print("Handle other errors");
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  void capture () {
    img.Image image = img.Image.fromBytes(
        _cameraImage.width,
        _cameraImage.height,
        _cameraImage.planes[0].bytes,
        format: img.Format.bgra
    );

    Uint8List jpeg = Uint8List.fromList(img.encodeJpg(image));
    _imageList.add(jpeg);
    _imageList.refresh();
  }

  void initTFLite() async{
    interpreter = await Interpreter.fromAsset('assets/mobilenet.tflite');
  }
}