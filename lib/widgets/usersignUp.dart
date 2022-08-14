import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../models/user.dart' as u;

class UserSignUp extends StatefulWidget {
  final Function() onClickedSignIn;
  const UserSignUp({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _passwordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    final docUser = FirebaseFirestore.instance.collection('users');

    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User registeredUser = result.user!;

      final user = u.User(
        uId: registeredUser.uid,
        uName: userNameController.text,
        uEmail: emailController.text.trim(),
      );

      final json = user.toJson();
      await docUser.doc(registeredUser.uid).set(json);
      await registeredUser.reload();
      await registeredUser.updateDisplayName(userNameController.text);

      //await FirebaseAuth.instance.currentUser!
      //.updateDisplayName(userNameController.text);

    } on FirebaseAuthException catch (e) {
      // Utils.showSnackBar(e.message, Colors.red);
      print(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 400,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 60,
                  maxHeight: 55,
                ),
                child: Image.asset('assets/images/logo-leaf.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'BOOKSHELF',
                style: TextStyle(
                  fontFamily: 'GothicA1-Regular',
                  fontSize: 24,
                  color: Color.fromRGBO(12, 12, 12, 1),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: TextFormField(
                  controller: userNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: TextFormField(
                  obscureText: _passwordVisible,
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'GothicA1-Regular',
                      fontSize: 10,
                      color: Color.fromRGBO(102, 102, 102, 1),
                    ),
                    text: 'Already have an account? ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Sign in',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 10,
                          color: Color.fromRGBO(12, 12, 12, 1),
                          fontFamily: 'GothicA1-SemiBold',
                        ),
                      )
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: signUp,
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontFamily: 'GothicA1-Regular',
                    fontSize: 24,
                    color: Color.fromRGBO(12, 12, 12, 0.85),
                  ),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Color.fromARGB(255, 143, 143, 143);
                    } else {
                      return Color.fromRGBO(255, 255, 255, 1);
                    }
                  }),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(
                        color: Color.fromRGBO(12, 12, 12, 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
