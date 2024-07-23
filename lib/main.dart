import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';
import 'user_signup.dart';
import 'user_login.dart';
import 'Verification.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // Your theme data
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) =>  OnBoardingScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/verification': (context) => Verification("String"),
        '/home': (context) => HomePage(),

      },
    );
  }
}
