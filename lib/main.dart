import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'Configuracion.dart';
import 'dart:io';
import 'aleatorios.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detección de Plantas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.green,
        textTheme: TextTheme(
          headlineSmall: GoogleFonts.roboto( 
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.green[800],
          ),
          bodyMedium: GoogleFonts.openSans( 
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
      home: CameraScreen(),
    );
  }
}
 
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  double? _confidenceRate;
  String? _enfermedad;
  String? _informacion;
  String? _tratamiento;

  double _imageWidth = 100.0;
  double _imageHeight = 100.0;

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
        _confidenceRate = DataGenerator.generateConfidenceRate();
        _enfermedad = DataGenerator.generateEnfermedad();
        _informacion = DataGenerator.generateInformacion();
        _tratamiento = DataGenerator.generateTratamiento();
      });
    }
  }

  void _clearPicture() {
    setState(() {
      _image = null;
      _confidenceRate = null;
      _enfermedad = null;
      _informacion = null;
      _tratamiento = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.0),
        child: AppBar(
          backgroundColor:
              Colors.white, 
          elevation: 0, 
          title: Text(
            'Detección de Enfermedades Para plantas de tuna',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green[800],
            ),
            textAlign: TextAlign.center, 
            overflow: TextOverflow
                .ellipsis, 
            softWrap: true, 
          ),

          centerTitle: true, 
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.settings, color: Colors.green[800]),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); 
                },
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[100],
              ),
              child: Center(
                child: Text(
                  'Opciones',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Configuración'),
              leading: Icon(Icons.settings, color: Colors.green),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
                if (result != null && result is Map<String, double>) {
                  setState(() {
                    _imageWidth = result['imageWidth'] ?? _imageWidth;
                    _imageHeight = result['imageHeight'] ?? _imageHeight;
                  });
                }
                Navigator.pop(context); 
              },
            ),
            ListTile(
              title: Text('Cargar Modelo'), 
              leading: Icon(Icons.upload, color: Colors.green),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20.0), 
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _takePicture,
                  child: Text('Abrir cámara'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                ),
                SizedBox(height: 30),
                _image == null
                    ? Text(
                        'No has tomado ninguna foto',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : Column(
                        children: [
                          Container(
                            width: _imageWidth,
                            height: _imageHeight,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green[400]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información de la planta',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Información: ${_informacion ?? "Texto de ejemplo"}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Enfermedad: ${_enfermedad ?? "Texto de ejemplo"}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Tratamiento: ${_tratamiento ?? "Texto de ejemplo"}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Tasa de confianza:',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: _confidenceRate ?? 0.0,
                                    backgroundColor: Colors.green[100],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green[600]!),
                                    minHeight: 10,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${((_confidenceRate ?? 0.0) * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
