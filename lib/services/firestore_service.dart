import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keepr/services/SecureStorageService.dart';
import 'package:keepr/services/encrpton_services.dart';

import 'firebase_auth.dart';

class FirebaseStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserData(String userId, String email, String firstName, String lastName) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName
        // Add more user-related data fields here as needed
      });
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try{
      DocumentSnapshot<Map<String,dynamic>> userDoc = await _firestore.collection('users').doc(uid).get();
      if(userDoc.exists){
        return userDoc.data();
      }else{
        print('User document does not exist');
        return null;
      }
    }catch(e){
      print('Error getting user data: $e');
      return null;
    }
  }
  void AddForm(_formKey, accountNameController, accountEmailController, passwordController, accountTypeController) async {
    if (_formKey.currentState!.validate()) {
      final accountName = accountNameController.text;
      final accountEmail = accountEmailController.text;
      final password = passwordController.text;
      final accountType = accountTypeController.text;

      if (password.isEmpty) {
        // Handle the case where the password is empty
        print('Error: Password cannot be empty.');
        return;
      }

      String? userUid = FirebaseAuthService().getCurrentUserUid();
      SecureStorageService storageService = SecureStorageService();
      var masterPassword = await storageService.getMasterPassword(); // Use await to get the Future<String?>

      if (masterPassword != null) {
        // EncryptionService _encryptionService = EncryptionService(masterPassword); // Initialize your encryption service
        //
        // String encryptedPassword = await _encryptionService.encrypt(password);

        EncryptionService _encryptionService = EncryptionService();
        Encrypted encryptedData = _encryptionService.encrypt(masterPassword, password);
        print(password);
        print("Data Encrpyed: ${encryptedData.base64}");

        Map<String, dynamic> formData = {
          'accountName': accountName,
          'accountEmail': accountEmail,
          'accountPassword': encryptedData.base64, // Store the hashed password
          'accountType': accountType,
        };

        FirebaseFirestore.instance.collection('users').doc(userUid).collection('SMAccounts').add(formData);

        // Clear text fields after successful submission
        accountNameController.clear();
        accountEmailController.clear();
        passwordController.clear();
        accountTypeController.clear();
      } else {
        // Handle the case where master password retrieval fails (null value)
        print('Error: Master password retrieval failed.');
      }
    }
  }




  void UpdateDocument(documentId, emailController, typeController,passwordController,nameController) async{
    final email = emailController.text;
    final accountType = typeController.text;
    final password = passwordController.text;
    final accountName = nameController.text;

    String? userid = FirebaseAuthService().getCurrentUserUid();

    SecureStorageService storageService = SecureStorageService();
    var masterPassword = await storageService.getMasterPassword();

    EncryptionService _encryptionService = EncryptionService();
    Encrypted encryptedData = _encryptionService.encrypt(masterPassword!, password);
    print(password);

    print("Data Encrpyed: ${encryptedData.base64}");

    Map<String, dynamic> formData = {
      'accountName': accountName,
      'accountEmail': email,
      'accountPassword': encryptedData.base64,
      'accountType': accountType,
    };

    CollectionReference smAccounts = FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .collection('SMAccounts');

    if (documentId.isNotEmpty) { // Check if documentId is not null or empty
      DocumentSnapshot doc = await smAccounts.doc(documentId).get();
      if (doc.exists) {
        await smAccounts.doc(documentId).update(formData);
      } else {
        await smAccounts.doc(documentId).set(formData);
      }

      // //TODO: Add toast to show successfull completion
      // final snackBar = SnackBar(
      //   content: Text('Successfully Updated'),
      // );
      //
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //
      // Navigator.pop(context);
    } else {
      print('DocumentId is null or empty.');
    }
  }


}