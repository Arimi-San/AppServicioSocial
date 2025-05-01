import 'dart:math';
class DataGenerator {
  static final List<String> _enfermedades = [
    'Mildiu',
    'Oídio',
    'Mancha negra',
    'Tizón temprano',
    'Tizón tardío'
  ];

  static final List<String> _informacion = [
    'Hongo que afecta las hojas.',
    'Infección bacteriana común.',
    'Daño causado por plagas.',
    'Deficiencia de nutrientes.',
    'Daño por exceso de agua.'
  ];

  static final List<String> _tratamientos = [
    'Aplicar fungicida específico.',
    'Mantener las hojas secas y usar azufre en polvo.',
    'Rociar con insecticida natural.',
    'Usar fertilizantes ricos en nitrógeno.',
    'Controlar el riego y aplicar bicarbonato de sodio.'
  ];

  static double generateConfidenceRate() {
    return (Random().nextDouble() * 0.5) + 0.5; 
  }

  static String generateEnfermedad() {
    return _enfermedades[Random().nextInt(_enfermedades.length)];
  }

  static String generateInformacion() {
    return _informacion[Random().nextInt(_informacion.length)];
  }

  
  static String generateTratamiento() {
    return _tratamientos[Random().nextInt(_tratamientos.length)];
  }
}
