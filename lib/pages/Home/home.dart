import 'package:bookshelf/widgets/addBook.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:nanoid/nanoid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final curUser = FirebaseAuth.instance.currentUser!;
  final books = FirebaseFirestore.instance.collection('books');

  Future signOut() async {
    FirebaseAuth.instance.signOut();
  }

  void deleteBook(String bookId) {
    books.where('id', isEqualTo: bookId).get().then((selectedBook) {
      if (selectedBook.docs.isNotEmpty) {
        for (var item in selectedBook.docs) {
          item.reference.delete();
        }
      }
    });
  }

  void addBook() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            child: addUserBooks(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    // padding: EdgeInsets.all(15),
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/prof-pic.png'),
                      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                      radius: 45.0,
                    ),
                  ),
                  Text('Hello, ${curUser.displayName}'),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: Text(
                    "My Books",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  title: Text(
                    "Completed",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  title: Text(
                    "Unfinished",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 250,
                ),
                TextButton(
                    onPressed: signOut,
                    child: Text(
                      "Log Out",
                      style: TextStyle(color: Color.fromRGBO(12, 12, 12, 1)),
                    ))
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "BOOKSHELF",
          style: TextStyle(
            color: Color.fromRGBO(12, 12, 12, 1),
            fontFamily: "GothicA1-Regular",
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: Color.fromRGBO(12, 12, 12, 1),
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/prof-pic.png'),
              backgroundColor: Color.fromRGBO(0, 0, 0, 1),
              radius: 20.0,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: books
            .where('createdBy', isEqualTo: curUser.uid)
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(0, 0, 0, 1)),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView(
                  padding: EdgeInsets.only(top: 10),
                  children: [
                    ListTile(
                      leading: Container(
                        // padding: EdgeInsets.only(left: 17),
                        child: Text(
                          'All Books',
                          style: TextStyle(
                            fontFamily: 'GothicA1-Bold',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(CupertinoIcons.add),
                        color: Color.fromRGBO(0, 0, 0, 1),
                        onPressed: addBook,
                      ),
                    ),
                    ...snapshot.data!.docs.map(
                      (book) {
                        return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                // color: Color.fromARGB(255, 185, 251, 241),
                                border: Border.all(
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                              child: FittedBox(
                                child: Text(
                                  book['title'],
                                  style: TextStyle(
                                    fontFamily: 'GothicA1-Bold',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(book['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['description'],
                                  style: TextStyle(
                                    fontFamily: 'GothicA1-Medium',
                                  ),
                                ),
                                Text(
                                  'Status: ${book['status']}',
                                  style: TextStyle(
                                    fontFamily: 'GothicA1-SemiBold',
                                  ),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              onPressed: () => deleteBook(book['id']),
                              icon: Icon(
                                CupertinoIcons.trash_circle,
                              ),
                            ));
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
