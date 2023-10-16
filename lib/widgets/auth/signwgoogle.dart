import 'package:flutter/material.dart';

class SignInWithGoogle extends StatelessWidget {
  const SignInWithGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.gpp_good)
          ),
          Text(
            'Sign In With Google',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
