import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/mappers/core_exception_mapper.dart';
import '../data/mappers/firebase_exception_mapper.dart';

part 'core_di_providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
CoreExceptionMapper coreExceptionMapper(Ref ref) {
  return const CoreExceptionMapperImpl();
}

@riverpod
FirebaseExceptionMapper firebaseExceptionMapper(Ref ref) {
  return const FirebaseExceptionMapperImpl();
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

@riverpod
String? currentUserId(Ref ref) {
  return ref.watch(authStateChangesProvider).value?.uid;
}