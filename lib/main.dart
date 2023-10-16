import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keepr/screens/HomePage/homepage.dart';
import 'package:keepr/screens/NotePage/notepage.dart';
import 'package:keepr/screens/SettingsPage/settings.dart';
import 'package:keepr/screens/auth/signup.dart';
import 'package:keepr/screens/auth/login.dart';
import 'package:keepr/screens/splash_screens/masterPasswordScreen.dart';
import 'package:keepr/screens/splash_screens/splash1.dart';
import 'package:keepr/services/SecureStorageService.dart';
import 'package:keepr/services/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);


  bool isMasterPasswordSet = await checkIfMasterPasswordSet();

  runApp(
     MyApp(isMasterPasswordSet: isMasterPasswordSet)
  );
}

  Future<bool> checkIfMasterPasswordSet() async {
    final secureStorage = SecureStorageService();
    return await secureStorage.isMasterPasswordSet();
  }
class MyApp extends StatelessWidget {
  final bool isMasterPasswordSet;

  const MyApp({Key? key, required this.isMasterPasswordSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final lightTheme = ThemeData(
        dividerTheme: DividerThemeData(
          thickness: 1, // Set the default thickness for dividers
          indent: 16, // Set the default left indentation for dividers
          endIndent: 16, // Set the default right indentation for dividers
        ),
        brightness: Brightness.light,
        primaryColor: Color(0xff95b9d9), // Main color for light mode
        hintColor: Color(0xff32495a),
        primarySwatch: Colors.blueGrey

      // Accent color for light mode
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark, // Set to dark mode
      primaryColor: Color(0xff95b9d9), // Main color for dark mode
      hintColor: Color(0xff57779b), // Accent color for dark mode
      primarySwatch: Colors.blueGrey,

    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) {
          return FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              } else if (snapshot.hasData) {
                if (isMasterPasswordSet) {
                  return HomePage();
                } else {
                  return MasterPasswordScreen();
                }
              } else {
                return LogInPage();
              }
            },
          );
        },
        '/login': (context) => LogInPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/notes': (context) => NotePage(),
        '/settings': (context) => SettingsPage(),
        '/master': (context) => MasterPasswordScreen(),

      },
    );
  }


}
