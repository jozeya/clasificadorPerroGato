import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img; // Importa el paquete image


import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ScanController extends GetxController{
  late Interpreter interpreter;
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraImage cameraImage;
  List<Uint8List> inputValue = [];

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initInterpreter('assets/mobilenet.tflite');
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

  initInterpreter(String path) async{
    interpreter = await Interpreter.fromAsset(path);
  }

  objectDetector(CameraImage image) async{

    // Supongamos que tienes una instancia de CameraImage llamada cameraImage
    // Y has extraído los datos de la imagen en un Uint8List llamado imageData
    // Supongamos que también tienes una ruta de archivo donde quieres guardar la imagen

    // guardarEnGaleria(File('/imagen.jpg'));
    // String filePath = await _getPathForImageInGallery(); // Cambia esto por la ruta real
    // filePath += '/imagen.jpg';
    // String filePath = '/storage/emulated/0/DCIM/figura.txt';
    String filePath = '/storage/emulated/0/DCIM/image.png';
    print(image.width);
    print(image.height);
    print(image.planes[0].bytes.shape);

    Uint8List imageBytes = image.planes[0].bytes;
    //convert bytedata to image
    img.Image? bitmap = img.decodeImage(imageBytes);
    if (bitmap != null){
      //then save on your directories use path_provider package to get all directories you are able to save in a device
      File("/storage/emulated/0/DCIM/image.jpg").writeAsBytesSync(img.encodeJpg(bitmap));
      // or as png
      File("/storage/emulated/0/DCIM/image.png").writeAsBytesSync(img.encodePng(bitmap));
    }else{
      print("bitmap vacio");
    }


    // await guardarUint8ListEnArchivo([image.planes[0].bytes], filePath);
    //await guardarImagen(image, filePath);
    // guardarPlaneComoJPEG(image.planes[0].bytes, image.width, image.height, filePath).then((_) {
    //     print('Imagen guardada correctamente en: $filePath');
    //   }).catchError((error) {
    //     print('Error al guardar la imagen: $error');
    // });

    // // Guardar los bits de la imagen en el archivo
    // saveImageToFile(image.planes[0].bytes, filePath).then((_) {
    //   print('Imagen guardada correctamente en: $filePath');
    // }).catchError((error) {
    //   print('Error al guardar la imagen: $error');
    //   print(filePath);
    // });

    // Image temp = await resizeImage(image.planes[0].bytes, image.width, image.height, 100, 100);

    // print(temp.width);
    // print(temp.height);
    // print(temp);
    // inputValue =  image.planes.map((e) => e.bytes).toList();
    // print(inputValue.length);
    // print(inputValue.shape);
    // print(inputValue[0].length);
    // print(inputValue[1].length);
    // print(inputValue[2].length);
  }

  // Future<ui.Image> resizeImage(Uint8List imageData, int originalWidth, int originalHeight, int newWidth, int newHeight) async {
  //   // Decodificar la imagen desde el Uint8List
  //   Codec codec = await instantiateImageCodec(imageData);
  //   FrameInfo frameInfo = await codec.getNextFrame();
  //
  //   // Obtener la imagen original
  //   Image originalImage = frameInfo.image;
  //
  //   // Redimensionar la imagen utilizando un objeto PictureRecorder y Canvas
  //   PictureRecorder recorder = PictureRecorder();
  //   Canvas canvas = Canvas(recorder);
  //   canvas.drawImageRect(
  //     originalImage,
  //     Rect.fromLTRB(0, 0, originalWidth.toDouble(), originalHeight.toDouble()),
  //     Rect.fromLTRB(0, 0, newWidth.toDouble(), newHeight.toDouble()),
  //     Paint(),
  //   );
  //   Image resizedImage = await recorder.endRecording().toImage(newWidth, newHeight);
  //
  //   return resizedImage;
  // }

  Future<void> saveImageToFile(Uint8List imageData, String filePath) async {
    File file = File(filePath);
    IOSink sink = file.openWrite(mode: FileMode.write);

    sink.add(imageData);
    await sink.close();
  }

  // Función para guardar un plano en un archivo JPEG
  Future<void> guardarPlaneComoJPEG(Uint8List planeData, int width, int height, String filePath) async {
    img.Image image = img.Image(width: width, height: height);
    image = img.Image.fromBytes(width: width, height: height, bytes: planeData.buffer);

    // Guardar la imagen en formato JPEG
    File file = File(filePath);
    await file.writeAsBytes(img.encodeJpg(image));
  }

  Future<void> guardarUint8ListEnArchivo(List<Uint8List> lista, String filePath) async {
    // Abre el archivo para escritura
    File file = File(filePath);
    IOSink sink = file.openWrite();

    try {
      // Itera sobre cada Uint8List en la lista
      for (Uint8List uint8List in lista) {
        // Convierte el Uint8List a una cadena Base64
        String base64String = base64Encode(uint8List);
        // Escribe la cadena en el archivo
        sink.write('$base64String\n');
      }
    } catch (e) {
      // Maneja cualquier error que ocurra
      print('Error al escribir en el archivo: $e');
    } finally {
      // Cierra el archivo después de escribir todas las Uint8List
      await sink.close();
    }
  }
  // Función para guardar una imagen representada por un objeto CameraImage
  Future<void> guardarImagen(CameraImage cameraImage, String filePath) async {
    try {
      // Convierte la imagen de formato CameraImage a un formato de imagen estándar (JPEG o PNG)
      img.Image image = _convertirCameraImage(cameraImage);

      // Guarda la imagen en el archivo especificado
      File file = File(filePath);
      await file.writeAsBytes(img.encodeJpg(image)); // Cambia a encodePng si deseas guardar como PNG

      print('Imagen guardada en: $filePath');
    } catch (e) {
      print('Error al guardar la imagen: $e');
    }
  }

// Función para convertir un objeto CameraImage a un formato de imagen estándar
  img.Image _convertirCameraImage(CameraImage cameraImage) {
    // Obtén los datos de los planos YUV420
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    // Crea un Uint8List para los datos de la imagen
    final uvBuffer = cameraImage.planes[1].bytes;
    final imgData = Uint8List(cameraImage.width * cameraImage.height * 3 ~/ 2);

    // Convierte los datos de los planos YUV420 a un formato de imagen estándar
    int i = 0;
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        final int uvIndex = row ~/ 2 * uvRowStride + col ~/ 2 * uvPixelStride;
        final int y = cameraImage.planes[0].bytes[row * width + col];
        final int u = uvBuffer[uvIndex];
        final int v = uvBuffer[uvIndex + 1];

        // Convierte YUV a RGB
        final r = (y + 1.402 * (v - 128)).clamp(0, 255).toInt();
        final g = (y - 0.344 * (u - 128) - 0.714 * (v - 128)).clamp(0, 255).toInt();
        final b = (y + 1.772 * (u - 128)).clamp(0, 255).toInt();

        // Asigna los valores RGB a la lista de datos de la imagen
        imgData[i++] = r;
        imgData[i++] = g;
        imgData[i++] = b;
      }
    }

    // Crea una imagen utilizando el paquete image
    return img.Image.fromBytes(width:  width,height:  height,bytes:  imgData.buffer);
  }


}