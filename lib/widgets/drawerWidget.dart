import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).hintColor), // Set text color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).hintColor), // Set text color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Image
                  Image.asset(
                    'assets/app-logo.png', // Replace 'your_image.png' with your image asset path
                    height: 60, // Adjust the height of the image according to your preference
                  ),
                  SizedBox(width: 20), // Add spacing between image and text
                  // Text
                  Text(
                    'KEEPR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Dashboard',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.dashboard, color: Theme.of(context).hintColor),
            onTap: () {
              Navigator.pushReplacementNamed(context,'/home');
            },
          ),
          ListTile(
            title: Text(
              'Secure Notes',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.note, color: Theme.of(context).hintColor),
            onTap: () {
              Navigator.pushReplacementNamed(context,'/notes');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box, color: Theme.of(context).hintColor),
            title: Text(
              'Account',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Handle the onTap action for Account
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).hintColor),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 16),
            ),
            onTap: _showLogoutConfirmationDialog,
            
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).hintColor),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context,'/settings');
            },
          ),
        ],
      ),
    );
  }
}
