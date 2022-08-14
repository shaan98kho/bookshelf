import 'package:bookshelf/pages/Home/home.dart';

import './widgets/userLogin.dart';
import './auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: StreamBuilder<User?>(
          //streambuilder ensures that as long as user did not click log out button, they will always stay signed in
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return AuthPage();
            } else {
              return HomePage();
            }
          }),
    );
  }
}
