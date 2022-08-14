import 'package:bookshelf/auth.dart';

import './loginpage.dart';
import './widgets/userLogin.dart';
import './widgets/userSignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: const FirebaseOptions(
    // apiKey: 'AIzaSyBZqz4SSaZxIkNNJEbUvy9OysW9WLWBf0E',
    // appId: '1:1057318211753:web:8a11fc143fc9ffaccdd9b8',
    // messagingSenderId: '1057318211753',
    // projectId: 'nutritsy',
    options: const FirebaseOptions(
      apiKey: "AIzaSyBMKpdHo16-MhkdLYKuZo26etuWY2Dv89k",
      authDomain: "bookshelf-5212b.firebaseapp.com",
      projectId: "bookshelf-5212b",
      storageBucket: "bookshelf-5212b.appspot.com",
      messagingSenderId: "299393802036",
      appId: "1:299393802036:web:ed7cc75b228f407afbcf61",
    ),
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Bookshelf',
      home: const Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: LoginPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
