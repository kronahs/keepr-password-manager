import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keepr/services/SecureStorageService.dart';

import '../../widgets/MasterPassword/pin_textfield.dart';

class MasterPasswordScreen extends StatefulWidget {
  @override
  _MasterPasswordScreenState createState() => _MasterPasswordScreenState();
}

class _MasterPasswordScreenState extends State<MasterPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final SecureStorageService _storageService = SecureStorageService();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Master Password'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/1.5, // Set the desired width for the input field
                decoration: BoxDecoration(
                  color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    maxLength: 4, // Limit the input to 6 characters
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
                      LengthLimitingTextInputFormatter(4), // Limit input length to 6 characters
                    ],
                    keyboardType: TextInputType.number, // Set keyboard type to number
                    decoration: InputDecoration(
                      hintText: 'Master Pin',
                      border: InputBorder.none,
                        counterText: ''
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _handleMasterPasswordSubmission();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text('Submit', style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set your desired button color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMasterPasswordSubmission() async {
    String masterPassword = _passwordController.text;
    await _storageService.saveMasterPassword(masterPassword);

    Navigator.pushReplacementNamed(context, '/home');
  }
}
