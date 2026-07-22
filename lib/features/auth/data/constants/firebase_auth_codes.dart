/// Códigos de error específicos de Firebase Authentication.
abstract final class FirebaseAuthCodes {
  static const wrongPassword = 'wrong-password';
  static const userNotFound = 'user-not-found';
  static const invalidCredential = 'invalid-credential';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const tooManyRequests = 'too-many-requests';
  static const networkRequestFailed = 'network-request-failed';
}
