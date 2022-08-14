import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/nanoid.dart';
import '../main.dart';

class addUserBooks extends StatefulWidget {
  const addUserBooks({Key? key}) : super(key: key);

  @override
  State<addUserBooks> createState() => _addUserBooksState();
}

class _addUserBooksState extends State<addUserBooks> {
  final formKey = GlobalKey<FormState>();
  final curUser = FirebaseAuth.instance.currentUser!;
  final books = FirebaseFirestore.instance.collection('books');
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final statusController = TextEditingController();
  final authorController = TextEditingController();
  String dropdownValue = 'Completed';

  String? selectedStatus;
  // statusController.text = selectedStatus;
  List<String> userBookStatus = [
    'Completed',
    'Unfinished',
  ];

  void addBooks() {
    final randomId = nanoid();
    books.doc(randomId).set({
      'title': titleController.text,
      'author': authorController.text,
      'description': descriptionController.text,
      'status': statusController.text,
      'createdBy': curUser.uid,
      'id': randomId,
    }).then((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.25, 20,
          MediaQuery.of(context).size.width * 0.25, 20),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: 'Author',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButton<String>(
              hint: Text('Select your current status'),
              value: selectedStatus,
              items: userBookStatus.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedStatus = value as String;
                  statusController.text = selectedStatus!;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: addBooks,
              child: Text(
                'Submit',
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
            ),
          ],
        ),
      ),
    );
  }
}
