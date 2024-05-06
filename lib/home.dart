import 'package:cat_dog/database/tf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<Interpreter> interpreter;

  // For ex: if input tensor shape [1,5] and type is float32
  var input = [[1.23, 6.54, 7.81, 3.21, 2.22]];

  // if output tensor shape [1,2] and type is float32
  var output = List.filled(1*2, 0).reshape([1,2]);

  @override
  void initState() {
    interpreter = Interpreter.fromAsset('assets/mobilenet.tflite');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home")
      ),
      body: FutureBuilder(
        future: interpreter,
        builder: (context, snapshot){
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return CircularProgressIndicator();
          // } else if (snapshot.hasError) {
          //   return Text('Error al cargar el modelo: ${snapshot.error}');
          // } else {
          //   // Realizar reshape de los datos cargados
          //   List<List<dynamic>> datosReshape = reshapeDatos(snapshot.data);
          //   return Text('Datos cargados con éxito y reshape realizado: $datosReshape');
          // }
          if (snapshot.hasData){
            Interpreter intpr = snapshot.data!;
            print(intpr.getInputTensor(0));
            print(intpr.getOutputTensor(0));

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    List  input = await _loadLabels();
                    input.map( (e) => print(e)).toList();
                  },
                  child: Text("Cargar")
                ),
                ElevatedButton(
                    onPressed: () {

                    },
                    child: Text("Iniciar")
                )
              ],
            );
          }else{
            return const Center(child: Text("Sin datos"));
          }
        } ,
      ),
    );
  }

  Future<dynamic> cargarModeloTFLite() async {
    var interpreter = await Interpreter.fromAsset('assets/mobilenet.tflite');
    return interpreter.getInputTensor(0); // Obtener los datos de entrada del modelo
  }

  // Load labels from assets
  Future _loadLabels() async {
    List labels = [];
    final labelTxt = await rootBundle.loadString('assets/input_test.txt');
    labels = labelTxt.split('\n');
    return labels;
  }

  // List<List<dynamic>> reshapeDatos(Tensor datos) {
  //   // Aplanar los datos a una forma bidimensional (10000, 1)
  //   List<List<dynamic>> datosReshape = [];
  //   for (var fila in datos) {
  //     for (var valor in fila) {
  //       datosReshape.add([valor]);
  //     }
  //   }
  //   return datosReshape;
  // }


}
