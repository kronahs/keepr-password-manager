import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keepr/widgets/auth/signwgoogle.dart';
import 'signup.dart';
import 'package:keepr/services/firebase_auth.dart';

import '../../widgets/auth/signwapple.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff95b9d9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SizedBox(height: 70,),
                    Text('LogIn', style: TextStyle(fontSize: 40,color: Colors.white),),
                    SizedBox(height: 30,),
                    SignInWithApple(),
                    SizedBox(height: 10,),
                    SignInWithGoogle(),
                  ],
                ),
                LogInForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({Key? key}) : super(key: key);

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              hintText: 'Enter your email',
            ),
          ),
          SizedBox(height: 16.0), // Add some spacing between email and password fields
          TextFormField(
            controller: _passwordController,
            obscureText: true, // To obscure the password text
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              hintText: 'Enter your password',
            ),
          ),
          SizedBox(height: 24.0), // Add more spacing at the end of the form
          ElevatedButton(
            onPressed: () {
              _signIn();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // White background
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Border radius of 12
                ),
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(
                  color: Colors.blueGrey, // Blue-grey text color
                  fontSize: 18.0, // Adjust the font size as needed
                ),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 50.0), // Set the button size to your preferred dimensions
              ),
            ),
            child: Text('Log In', style: TextStyle(color: Color(0xff32495a), fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 16.0), // Add spacing between the button and the link
          RichText(
            text: TextSpan(
              text: 'Dont have an account? ',
              style: TextStyle(
                color: Color(0xff32495a),
                fontSize: 16.0,
              ),
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    color: Colors.white, // Use blue color for the link
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  // Add a gesture recognizer to handle the tap on the link
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, "/signup");
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async{
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.SignInWithEmailAndPassword(email, password);
    if(user != null){
      print("User is successfully Signed In");
      Navigator.pushNamed(context, '/home');
    }
    else{
      print('Couldnt Sign In User');
      final snackBar = SnackBar(
        content: Text('Login failed. Please check your email and password and try again.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}



