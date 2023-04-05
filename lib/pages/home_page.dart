import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData(user.uid);
  }

  Future addData(String title, String content, String uid) async {
    await db.collection("notes-${user.uid}").add({
      'title': title,
      'content': content,
      'time': DateTime.now().toString()
    });
  }

  List<String> datas = [];

  Future getData(String uid) async {
    final notesRef = db.collection("notes-${user.uid}");
    QuerySnapshot<Map<String, dynamic>> deneme = await notesRef
        // .where("userId", isEqualTo: user.uid.toString())
        .orderBy("time", descending: true)
        .get();

    return deneme;
  }

  Future delData(String id) async {
    await db.collection("notes-${user.uid}").doc(id).delete();
    print("delete calıstı");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: getData(user.uid),
              builder: (BuildContext context, snapshot) {
                // List dataa = snapshot.data.docs;
                // if (snapshot.data != null) {
                if (snapshot.hasData) {
                  if ((snapshot.data.docs.length) == 0) {
                    return Text("data var ama bos ");
                  } else {
                    print(snapshot.data.docs.length);
                    // print(snapshot.data.docs.length);
                    return Container(
                      color: Colors.blue,
                      height: size.height * 0.5,
                      child: ListView.builder(
                        // itemCount: datas.length,
                        itemCount: snapshot.data.docs.length,

                        itemBuilder: (BuildContext context, int index) {
                          // final data = snapshot.data[index];
                          // if (snapshot.data.docs[index]["userId"] == user.uid) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      delData(snapshot.data.docs[index].id);
                                    },
                                    child: Column(
                                      children: [
                                        // Text(snapshot.data.docs[index]
                                        //     ["userId"]),
                                        Text(snapshot.data.docs[index]
                                            ["content"]),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  print("CircularProgressIndicator");
                  return CircularProgressIndicator();
                }
              },
            ),
            MaterialButton(
              onPressed: () {
                addData(
                  user.uid,
                  DateTime.now().toString(),
                  user.uid,
                );
                setState(
                  () {},
                );
              },
              color: Colors.deepPurple[200],
              child: Text("data ekle"),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Sign In as: " + user.email.toString() + " \n age :" + user.uid,
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple[200],
              child: Text("Sign Out"),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        )),
      ),
    );
  }
}
