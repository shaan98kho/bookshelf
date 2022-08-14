import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import '../main.dart';

class UserLogin extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const UserLogin({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      UserCredential result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final registeredUser = result.user!;
      await registeredUser.reload();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // switch (e.message) {
      //   case "The password is invalid or the user does not have a password.":
      //     navigatorKey.currentState!.popUntil((route) => route.isFirst);
      //     return;
      //   // return Utils.showSnackBar('Invalid password, try again!', Colors.red);

      //   case "There is no user record corresponding to this identifier. The user may have been deleted.":
      //     navigatorKey.currentState!.popUntil((route) => route.isFirst);
      //     return;
      //   // return Utils.showSnackBar(
      //   // 'There is no user registered to that email, try again!',
      //   // Colors.red);

      //   case "The email address is badly formatted.":
      //     navigatorKey.currentState!.popUntil((route) => route.isFirst);
      //     return;
      //   // return Utils.showSnackBar(
      //   // 'Invalid email format, try again!', Colors.red);
      // }
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 400,
        height: 500,
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
                height: 50,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email) ||
                              email == null
                          ? 'Enter a valid email'
                          : null,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _passwordVisible,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) {
                    if (password!.isEmpty) {
                      return 'This field must not be empty!';
                    } else {
                      return null;
                    }
                  },
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
                    text: 'Don\'t have an account yet?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Sign Up',
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
                onPressed: signIn,
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'GothicA1-Regular',
                    fontSize: 24,
                    color: Color.fromRGBO(12, 12, 12, 0.85),
                  ),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(50, 15, 50, 15),
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
