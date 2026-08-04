import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Lee un archivo JSON desde el directorio de pruebas y lo devuelve como un Map.
/// [path] es la ruta relativa desde la carpeta 'test/'.
/// [toFirestore] convierte las cadenas de fecha ISO8601 en objetos [Timestamp] de Firestore.
Map<String, dynamic> jsonReader(String path, {bool toFirestore = false}) {
  final dir = Directory.current.path;
  final file = File('$dir/test/$path');
  final Map<String, dynamic> jsonMap = json.decode(file.readAsStringSync());

  if (toFirestore) {
    return _convertToFirestore(jsonMap);
  }
  return jsonMap;
}

Map<String, dynamic> _convertToFirestore(Map<String, dynamic> map) {
  final newMap = <String, dynamic>{};
  map.forEach((key, value) {
    if (value is String && _isIsoDate(value)) {
      newMap[key] = Timestamp.fromDate(DateTime.parse(value));
    } else if (value is Map<String, dynamic>) {
      newMap[key] = _convertToFirestore(value);
    } else {
      newMap[key] = value;
    }
  });
  return newMap;
}

bool _isIsoDate(String value) {
  return RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}').hasMatch(value);
}
