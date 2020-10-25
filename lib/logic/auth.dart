//TODO : sign up as a teacher

import 'package:firebase_auth/firebase_auth.dart';

import 'fire.dart';

final _firebaseAuth = FirebaseAuth.instance;

final _fire = Fire();

class Auth {
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Student Email

  Future<String> signIn(String email, String password) async {
    try {
      final UserCredential cred = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return "Signed in";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'The email address is not valid';
        case 'user-disabled':
          return 'The user cooresponding to this email address has been disabled';
        case 'user-not-found':
          return 'No user exists with this email address. Please sign up first.';
        case 'wrong-password':
          return 'The password is incorrect';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      print(e);
      return 'An unknown error occurred';
    }
  }

  Future<String> signUpEmailStudent(
    String email,
    String password,
    String confirmPassword,
    String username,
    bool checkedBox,
  ) async {
    try {
      

      if (password != confirmPassword) {
        return 'Please make sure the password field matches the confirm password field';
      }
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

    

      // await _fire.setUpAccountStudent(email, username);

      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'That email is already in use';
        case 'email-already-in-use':
          return 'That email is not valid';
        case 'operation-not-allowed':
          return 'Email/Password sign in has been disabled';
        case 'weak-password':
          return 'Password is not strong enough';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

}
