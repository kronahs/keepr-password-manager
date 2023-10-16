
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firestore_service.dart';

class FirebaseAuthService {
  FirebaseAuth _auth  = FirebaseAuth.instance;

  Future<User?> SignUpWithEmailAndPassword (String email, String password, String firstName, String lastName) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Store additional user data in Firestore
        await FirebaseStoreServices().storeUserData(user.uid, email, firstName, lastName);
      }
      return user;
    } catch (e) {
      print('Error occurred on firebase auth: $e');
    }
    return null;
  }


  Future<User?> SignInWithEmailAndPassword (String email, String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch (e){
      print('Error occured on firebase auth: ${e}');
    }
    return null;
  }

  String? getCurrentUserUid() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }
}