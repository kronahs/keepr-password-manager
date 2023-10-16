import 'package:flutter/material.dart';

class SignInWithApple extends StatelessWidget {
  const SignInWithApple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the children horizontally
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.apple,
              color: Colors.white,
            ),
          ),
          Text(
            'Sign In With Apple',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
