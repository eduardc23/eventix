import 'dart:io';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Inicializa el entorno para las pruebas de integración (App uikit y Firebase).
Future<void> initializeIntegrationTestEnvironment() async {
  await AppKit.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/// Configura los servicios de Firebase para utilizar los emuladores locales.
Future<void> configureFirebaseEmulators({
  required FirebaseAuth auth,
  required FirebaseFirestore firestore,
  int authPort = 9099,
  int firestorePort = 8080,
}) async {
  final emulatorHost = resolveEmulatorHost();
  await auth.useAuthEmulator(emulatorHost, authPort);
  firestore.useFirestoreEmulator(emulatorHost, firestorePort);
}

/// Limpia las colecciones de Firestore para asegurar un estado limpio en las pruebas.
Future<void> resetIntegrationTestData({
  required FirebaseFirestore firestore,
  bool clearEvents = true,
  bool clearBookings = false,
}) async {
  if (clearEvents) {
    await clearCollection(firestore, 'events');
  }

  if (clearBookings) {
    await clearCollection(firestore, 'bookings');
  }
}

/// Elimina todos los documentos dentro de una colección específica de Firestore.
Future<void> clearCollection(
  FirebaseFirestore firestore,
  String collectionName,
) async {
  final snapshot = await firestore.collection(collectionName).get();
  for (final doc in snapshot.docs) {
    await doc.reference.delete();
  }
}

/// Crea un usuario de prueba único e inicia sesión con él.
Future<String> createAndSignInTestUser({
  required FirebaseAuth auth,
  required String prefix,
  required String password,
}) async {
  final email =
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}@example.com';

  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (error) {
    if (error.code != 'email-already-in-use') rethrow;
  }

  await auth.signInWithEmailAndPassword(email: email, password: password);

  return email;
}

/// Inserta un evento de prueba con datos predeterminados en Firestore.
Future<void> seedEvent({
  required FirebaseFirestore firestore,
  required String title,
  int availableSpots = 10,
  DateTime? date,
  String? eventId,
}) async {
  final reference = eventId == null
      ? firestore.collection('events').doc()
      : firestore.collection('events').doc(eventId);

  await reference.set({
    'title': title,
    'description': 'Evento de prueba',
    'categoryId': 'cat-1',
    'categoryName': 'Música',
    'cityId': 'city-1',
    'cityName': 'Madrid',
    'date': Timestamp.fromDate(
      date ?? DateTime.now().add(const Duration(days: 7)),
    ),
    'price': 0,
    'totalCapacity': 100,
    'availableSpots': availableSpots,
    'image_url': '',
    'status': 'active',
    'createdAt': FieldValue.serverTimestamp(),
  });
}

/// Determina la dirección IP del host de los emuladores según la plataforma (Android, iOS o local).
String resolveEmulatorHost() {
  if (Platform.environment.containsKey('EVENTIX_AUTH_EMULATOR_HOST') &&
      Platform.environment['EVENTIX_AUTH_EMULATOR_HOST']!.isNotEmpty) {
    return Platform.environment['EVENTIX_AUTH_EMULATOR_HOST']!;
  }

  if (Platform.isAndroid) {
    return '10.0.2.2';
  }

  if (Platform.isIOS) {
    return '127.0.0.1';
  }

  return 'localhost';
}
