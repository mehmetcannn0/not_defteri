import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_defteri/pages/detail.dart';
import 'package:not_defteri/pages/info_page.dart';
import 'package:not_defteri/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String fName = "";
  String lName = "";

  @override
  void initState() {
    super.initState();
    getProfile(user.uid);
    getDatas(user.uid);
  }

  Future getProfile(String uid) async {
    try {
      final notesRef = db.collection("users");
      QuerySnapshot<Map<String, dynamic>> document =
          await notesRef.where("userId", isEqualTo: user.uid.toString()).get();
      setState(() {
        lName = document.docs[0].data()["last name"];
        fName = document.docs[0].data()["first name"];
      });

      return document;
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Error: ${e.message}"),
          );
        },
      );
    }
  }

  Future addData(String title, String content, String uid) async {
    try {
      await db.collection("notes-${user.uid}").add({
        'title': title,
        'content': content,
        'time': DateTime.now().toString()
      });
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Error: ${e.message}"),
          );
        },
      );
    }
  }

  List<String> datas = [];

  Future getDatas(String uid) async {
    try {
      final notesRef = db.collection("notes-${user.uid}");
      QuerySnapshot<Map<String, dynamic>> documents =
          await notesRef.orderBy("time", descending: true).get();

      return documents;
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Error: ${e.message}"),
          );
        },
      );
    }
  }

  Future delData(String id) async {
    try {
      await db.collection("notes-${user.uid}").doc(id).delete();

      setState(() {});
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Error: ${e.message}"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            uid: user.uid,
                            id: "",
                          ))).then((value) {
                setState(() {});
              });
            },
            child: Icon(
              color: Theme.of(context).primaryColor,
              Icons.add,
              size: 35,
            ),
          )
        ],
      ),
      drawerScrimColor: Theme.of(context).backgroundColor.withOpacity(0.7),
      drawer: Container(
        width: 129,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  const CircleAvatar(
                      // backgroundImage: NetworkImage(user.photoURL.toString()),
                      ),
                  Text(fName),
                  Text(lName),
                ],
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfilePage()));
                },
                color: Colors.deepPurple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Icon(Icons.person_outline,
                        color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const InfoPage(),
                  ));
                },
                color: Colors.deepPurple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Info",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Icon(Icons.info_outline,
                        color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                color: Colors.deepPurple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sign Out",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Icon(Icons.logout, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: getDatas(user.uid),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data.docs.length) == 0) {
                    return const Text("No data, click the + to add :)");
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                            uid: user.uid,
                                            id: snapshot.data.docs[index].id,
                                          ))).then((value) => setState(() {}));

                              // print(snapshot.data.docs[index]["time"]);
                            },
                            child: Card(
                              color: Theme.of(context).primaryColor,
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 19, vertical: 9),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11.0),
                                child: ListTile(
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]["time"]
                                            .substring(0, 10),
                                      ),
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          text: 'Do you want to delete ?',
                                          confirmBtnText: 'Yes',
                                          cancelBtnText: 'No',
                                          confirmBtnColor: Colors.red,
                                          onConfirmBtnTap: () {
                                            delData(
                                                snapshot.data.docs[index].id);
                                            Navigator.pop(context);
                                          });
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]["title"],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )),
      ),
    );
  }
}
