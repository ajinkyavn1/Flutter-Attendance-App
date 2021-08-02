import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum userType { oldUser, newUser }

abstract class AuthBase {
  Stream<String> get onAuthStateChanged;

  Future<void> signout();

  Future<String> signinWithGoogle();
  Future<String> getCurrentUserID();

  Future<FirebaseUser> getCurrentUser();
}

class AuthProvider with ChangeNotifier implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  Future<String> signinWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn
          .signIn()
          .catchError((onError) => print(onError.toString()));
      if (account == null) return null;
      final GoogleSignInAuthentication _googleAuth =
          await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken,
      );
      AuthResult result = await _firebaseAuth.signInWithCredential(credential);

      result.additionalUserInfo.isNewUser;
      FirebaseUser user = result.user;
      return user.uid;
    } catch (e) {
      print('Exception in google login: $e');
      return null;
    }
  }

  @override
  Future<void> signout() async {
    _googleSignIn.signOut();
    return await _firebaseAuth.signOut();
  }

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

  // GET UID
  Future<String> getCurrentUserID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuth.currentUser();
  }
}
