import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventix/core/data/exceptions/app_exception.dart';
import 'package:eventix/core/domain/failures/app_failure.dart';
import 'package:mocktail/mocktail.dart';

/// Permite inyectar colecciones y manejar transacciones.
class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {
  FakeFirebaseFirestore({
    required this.collectionMocks,
    this.transactionProvider,
  });

  final Map<String, CollectionReference<Map<String, dynamic>>> collectionMocks;
  final Transaction Function()? transactionProvider;

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    if (collectionMocks.containsKey(path)) {
      return collectionMocks[path]!;
    }
    throw ArgumentError('Colección no registrada en FakeFirebaseFirestore: $path');
  }

  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    if (transactionProvider == null) {
      throw UnimplementedError('transactionProvider no configurado en FakeFirebaseFirestore');
    }
    return await transactionHandler(transactionProvider!());
  }
}

/// Fakes genéricos para errores y fallos
class FakeAppFailure extends Fake implements AppFailure {}
class FakeAppException extends Fake implements AppException {}
