import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keepr/services/firebase_auth.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:keepr/services/firestore_service.dart';




void showSMBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
    ),
    builder: (context) {
      return SocialMediaFormModal();
    },
  );
}

class SocialMediaFormModal extends StatefulWidget {
  @override
  _SocialMediaFormModalState createState() => _SocialMediaFormModalState();
}

class _SocialMediaFormModalState extends State<SocialMediaFormModal> {
  //final List<String> accountTypes = ['Facebook', 'Twitter', 'Instagram', 'LinkedIn', 'Reddit','Other'];
  //String selectedAccountType = 'Facebook';

  final accountNameController = TextEditingController();
  final accountEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final accountTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a form key


  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add Social Media Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: accountNameController,
                      decoration: InputDecoration(
                        labelText: 'Account Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: accountEmailController,
                      decoration: InputDecoration(
                        labelText: 'Account Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode? Colors.black54 : Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: accountTypeController,
                      decoration: InputDecoration(
                        labelText: 'Account Type',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account type';
                        }
                        return null;
                      },
                    ),
                  ),


                  SizedBox(height: 50),
                  Container(
                    color: Theme.of(context).hintColor,
                    child: TextButton(
                      onPressed: (){
                        FirebaseStoreServices().AddForm(_formKey, accountNameController, accountEmailController, passwordController, accountTypeController);
                        Navigator.of(context).pop(); // Close the modal

                      },
                      child: Text('Submit', style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),

      )
      );
  }
}
