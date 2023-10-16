import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keepr/services/firebase_auth.dart';
import 'package:keepr/services/firestore_service.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../services/SecureStorageService.dart';
import '../../services/encrpton_services.dart';
import '../../services/local_authentication_services.dart';

class SocialMediaDetailPage extends StatefulWidget {
  final String imageUrl; // URL for the social media account's logo image
  final String accountName;
  final String accountEmail;
  final String accountPassword;
  final String accountType;


  SocialMediaDetailPage({
    required this.imageUrl,
    required this.accountName,
    required this.accountEmail,
    required this.accountPassword,
    required this.accountType,
  }) {
    // Set initial values for the text fields

  }

  @override
  State<SocialMediaDetailPage> createState() => _SocialMediaDetailPageState();
}

class _SocialMediaDetailPageState extends State<SocialMediaDetailPage> {
  late PaletteGenerator _paletteGenerator;
  late  TextEditingController _emailController = TextEditingController();
  late TextEditingController _typeController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _nameController = TextEditingController();

  late String documentId = "";

  Future<void> _showPasswordDecryptionDialog() async {
    TextEditingController masterPasswordController = TextEditingController();
    bool isPasswordCorrect = false;
    EncryptionService encryptionService = EncryptionService();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Master Password'),
          content:               Container(
            width: MediaQuery.of(context).size.width/1.5, // Set the desired width for the input field
            decoration: BoxDecoration(
              color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: masterPasswordController,
                obscureText: true,
                maxLength: 4, // Limit the input to 4 characters
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
                  LengthLimitingTextInputFormatter(4), // Limit input length to 4 characters
                ],
                keyboardType: TextInputType.number, // Set keyboard type to number
                decoration: InputDecoration(
                  hintText: 'Master Pin',
                  border: InputBorder.none,
                  counterText: '', // Remove the character counter
                ),
              ),

            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Decrypt'),
              onPressed: () async {
                String? masterPassword = await SecureStorageService().getMasterPassword();
                if (masterPasswordController.text == masterPassword) {
                  try {
                    Encrypted encryptedPassword = Encrypted(base64.decode(widget.accountPassword)); // Assuming widget.accountPassword is base64 encoded

                    // Ensure the IV is exactly 16 bytes long
                    Uint8List ivBytes = Uint8List.fromList(utf8.encode(masterPasswordController.text.padRight(16))); // Pad the pin to ensure it's 16 bytes

                    IV iv = IV(ivBytes);

                    String decryptedPassword = await encryptionService.decrypt(masterPasswordController.text, encryptedPassword);
                    _passwordController.text = decryptedPassword;
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Handle decryption error here, e.g., show an error message to the user
                    print('Decryption Error: $e');
                    // Optionally, show an error dialog or a SnackBar to inform the user about the error.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to decrypt password. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  // Show error message for incorrect master password
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect master password. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },



            ),
          ],
        );
      },
    );

    // if (isPasswordCorrect) {
    //   // Decrypt the password and set it in the password controller
    //   String decryptedPassword = encryptionService.decrypt(widget.accountPassword,masterPasswordController.text);
    //   print("Master Password: "+widget.accountPassword, );
    //   _passwordController.text = decryptedPassword;
    // }
  }



  Future<void> getDocumentId() async {
    String? userId = FirebaseAuthService().getCurrentUserUid();
    print("USERID: $userId");
     // Replace this with the actual account name you are searching for

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('SMAccounts')
        .where('accountName', isEqualTo: widget.accountName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      documentId = querySnapshot.docs.first.id;
      print('DocumentId: $documentId');
    } else {
      print('Document not found.');
    }
  }



  // void updateDocument() async{
  //   final email = _emailController.text;
  //   final accountType = _typeController.text;
  //   final password = _passwordController.text;
  //   final accountName = _nameController.text;
  //
  //   String? userid = FirebaseAuthService().getCurrentUserUid();
  //
  //   Map<String, dynamic> formData = {
  //     'accountName': accountName,
  //     'accountEmail': email,
  //     'accountPassword': password,
  //     'accountType': accountType,
  //   };
  //
  //   CollectionReference smAccounts = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userid)
  //       .collection('SMAccounts');
  //
  //   if (documentId.isNotEmpty) { // Check if documentId is not null or empty
  //     DocumentSnapshot doc = await smAccounts.doc(documentId).get();
  //     if (doc.exists) {
  //       await smAccounts.doc(documentId).update(formData);
  //     } else {
  //       await smAccounts.doc(documentId).set(formData);
  //     }
  //
  //     //TODO: Add toast to show successfull completion
  //TODO: Toast shows on error
  //     final snackBar = SnackBar(
  //       content: Text('Successfully Updated'),
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //
  //     Navigator.pop(context);
  //   } else {
  //     print('DocumentId is null or empty.');
  //   }
  // }

  late FocusNode _nameFocusNode;
  bool _isKeyboardVisible = false;

  bool isReadOnly = true;
  bool isObscure = true;

  late LocalAuthenticationHelper _localAuthHelper;

  @override
  void initState(){
    super.initState();
    _emailController = TextEditingController(text: widget.accountEmail);
    _typeController = TextEditingController(text: widget.accountType);
    _passwordController = TextEditingController(text: widget.accountPassword);
    _nameController = TextEditingController(text: widget.accountName);
    _nameFocusNode = FocusNode();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _keyboardVisibilityListener();
      getDocumentId();
    });
    _generatePalette();

    _localAuthHelper = LocalAuthenticationHelper();

  }

  Color? dominantColor;
  Color? accentColor;

  Future<void> _generatePalette() async {
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(NetworkImage(widget.imageUrl));
    setState(() {
      _paletteGenerator = paletteGenerator;
      _updateColorsFromPalette();
    });
  }

  void _updateColorsFromPalette() {
    final Color? newDominantColor = _paletteGenerator?.dominantColor?.color;
    final Color? newAccentColor = _paletteGenerator?.vibrantColor?.color;

    if (newDominantColor != null) {
      setState(() {
        dominantColor = newDominantColor;
        accentColor = newDominantColor;
      });
    }

    if (newAccentColor != null) {
      setState(() {
        accentColor = newAccentColor;
      });
    }
  }

  void deleteDocument() async {
    try {
      String? userId = FirebaseAuthService().getCurrentUserUid();
      if (userId != null && documentId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('SMAccounts')
            .doc(documentId)
            .delete();

        final snackBar = SnackBar(
          content: Text('Document Deleted Successfully'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context); // Navigate back to the previous screen after deletion
      } else {
        final snackBar = SnackBar(
          content: Text('Document ID or User ID is invalid.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Document Failed to Delete: $e'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete',style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteDocument(); // Call the delete function
              },
            ),
          ],
        );
      },
    );
  }


  void _keyboardVisibilityListener() {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    setState(() {
      _isKeyboardVisible = isKeyboardVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        backgroundColor: dominantColor ?? Theme.of(context).primaryColor,
        elevation: 0.0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: dominantColor ?? Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white, // Background color for the logo square
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: isReadOnly,
                      focusNode: _nameFocusNode,
                      controller: _nameController, // Use the controller for this field
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Account Name',
                        //TODO: labelStyle: TextStyle(color: Colors.white)
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      readOnly: isReadOnly,
                      controller: _emailController, // Use the controller for this field
                      decoration: InputDecoration(labelText: 'Account Email'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      readOnly: isReadOnly,
                      controller: _typeController, // Use the controller for this field
                      decoration: InputDecoration(labelText: 'Account Type'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(child:                         TextFormField(
                          readOnly: isReadOnly,
                          controller: _passwordController, // Use the controller for this field
                          obscureText: isObscure,
                          decoration: InputDecoration(labelText: 'Account Password'),
                        ),),
                        IconButton(
                          onPressed: () async {
                            await _showPasswordDecryptionDialog() .then((value) => (
                                setState(() {
                                  isObscure = false;
                                })
                            ));
                            // if (isAuthenticated) {
                            //   setState(() {
                            //     isObscure = false;
                            //   });
                            // } else {
                            //   setState(() {
                            //     isObscure = true;
                            //   });
                            // }
                          },
                          icon: Icon(Icons.remove_red_eye),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 48),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: TextButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16), // Adjust vertical padding here
                      ),
                      child: Text('Delete'),
                    ),
                  )
                  // Add more fields as needed
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isKeyboardVisible
          ? null
          : FloatingActionButton(
        onPressed: () {
          if(isReadOnly){
            setState(() {
              isReadOnly = false;
            });
            _nameFocusNode.requestFocus();
          }else{
            //save user input
            FirebaseStoreServices().UpdateDocument(documentId, _emailController, _typeController, _passwordController, _nameController);
            final snackBar = SnackBar(
              content: Text('Successfully Updated'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.pop(context);
          }
        },
        backgroundColor: isReadOnly
            ? Theme.of(context).hintColor
            : accentColor,
        child: isReadOnly
            ? Icon(Icons.edit) // Change this icon to a save icon or appropriate icon
            : Icon(Icons.check),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),

    );
  }

}
