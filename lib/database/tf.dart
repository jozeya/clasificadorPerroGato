import 'package:tflite_flutter/tflite_flutter.dart';

class TfService{
  Interpreter interpreter;

  TfService(this.interpreter);

  Future loadAssets() async{
    await Interpreter.fromAsset('assets/mobilenet.tflite');
    return interpreter;
  }

}