import 'package:flutter/material.dart';

import './widgets/userLogin.dart';
import './widgets/userSignUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  void toggle() => setState(() => isLogin = !isLogin);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: isLogin
          ? UserLogin(onClickedSignUp: toggle)
          : UserSignUp(onClickedSignIn: toggle),
    );
  }
}
