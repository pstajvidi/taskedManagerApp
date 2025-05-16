import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<AuthResult> signUp(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return AuthResult(user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message ?? e.code);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  static Future<AuthResult> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return AuthResult(user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e.message ?? e.code);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

}

// Helper class to return both user and error
class AuthResult {
  final User? user;
  final String? error;

  AuthResult({this.user, this.error});
}