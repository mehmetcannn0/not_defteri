import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  String id;
  DetailPage({super.key, required this.id});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add"),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(widget.id),
            Column(
              children: [
                Container(
                  child: GestureDetector(
                    onTap: () {
                      addData(
                        widget.id,
                        DateTime.now().toString(),
                        widget.id,
                      );

                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: 'Note successfully saved!',
                        autoCloseDuration: Duration(seconds: 3),
                      ).then((value) => Navigator.pop(context));

                      // setState(
                      //   () {},
                      // );
                    },
                    child: Icon(Icons.save),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  Future addData(String title, String content, String uid) async {
    try {
      await db.collection("notes-$uid").add({
        'title': title,
        'content': content,
        'time': DateTime.now().toString()
      });
    } on FirebaseException catch (e) {
      print("hata :  ${e}");
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
}
