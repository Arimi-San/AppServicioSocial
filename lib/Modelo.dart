import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:file_picker/file_picker.dart'; 
import 'dart:io'; 
import 'package:flutter/cupertino.dart'; 

class TensorFlowLiteScreen extends StatefulWidget {
  @override
  _TensorFlowLiteScreenState createState() => _TensorFlowLiteScreenState();
}

class _TensorFlowLiteScreenState extends State<TensorFlowLiteScreen> {
  String _message = "Cargando modelo...";
  String _modelName = ""; 
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel(); 
  }


  Future<void> _loadModel() async {
    try {
      final interpreter = await Interpreter.fromAsset('images/1.tflite');
      setState(() {
        _interpreter = interpreter;
        _message = "Modelo cargado con éxito";
        _modelName = '1.tflite'; 
      });
    } catch (e) {
      setState(() {
        _message = "Error al cargar el modelo: $e";
      });
    }
  }

  Future<void> _pickNewModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['tflite'], 
    );

    if (result != null) {
      String path = result.files.single.path!;
      setState(() {
        _modelName = path.split('/').last; 
      });
      _loadNewModel(path); 
    } else {
      setState(() {
        _message = "No se seleccionó ningún archivo.";
      });
    }
  }

  Future<void> _loadNewModel(String modelPath) async {
    try {
      final interpreter = await Interpreter.fromFile(File(modelPath));
      setState(() {
        _interpreter = interpreter;
        _message = "Modelo cargado con éxito";
      });
    } catch (e) {
      setState(() {
        _message = "Error al cargar el modelo: $e";
      });
    }
  }

  @override
  void dispose() {
    _interpreter?.close(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TensorFlow Lite en Flutter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _modelName.isNotEmpty ? "Modelo cargado: $_modelName" : "No hay modelo cargado",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
           
            CupertinoButton(
              onPressed: _pickNewModel, 
              color: CupertinoColors.activeGreen, 
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              child: Text(
                "Cambiar Modelo",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
