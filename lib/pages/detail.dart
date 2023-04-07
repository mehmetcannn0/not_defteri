import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  String uid;
  String id;
  DetailPage({super.key, required this.uid, this.id = ""});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool update = false;
  @override
  initState() {
    super.initState();
    if (widget.id != "") {
      update = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future addData(String title, String content, String uid) async {
    try {
      final notesRef = db.collection("notes-$uid");
      await notesRef.add({
        'title': title,
        'content': content,
        'time': DateTime.now().toString()
      }).whenComplete(() => print("$title  $content  eklendi"));
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

  Future updateData(String title, String content, String uid, String id) async {
    try {
      final notesRef = db.collection("notes-$uid");
      await notesRef.doc(id).update({
        'title': title,
        'content': content,
        'time': DateTime.now().toString()
      }).whenComplete(() => print("$title  $content  guncellendı"));
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

  Future getData(String uid, String id) async {
    try {
      final notesRef = db.collection("notes-$uid");
      DocumentSnapshot<Map<String, dynamic>> document =
          await notesRef.doc(id).get();
      print(document.data());
      _titleController.text = document.data()!["title"];
      _contentController.text = document.data()!["content"];
      return document;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Add"),
        ),
        body: Center(
          child: FutureBuilder(
            future: update ? getData(widget.uid, widget.id) : null,
            builder: (BuildContext context, snapshot) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    // Text(widget.id),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).dialogBackgroundColor,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              onChanged: (value) => _titleController.text,
                              // initialValue: update.toString(),
                              // update ? "kljlk" : "_titleController.text",
                              maxLines: null,
                              textInputAction: TextInputAction.next,
                              controller: _titleController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Title',
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).dialogBackgroundColor,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              onChanged: (value) => _titleController.text,
                              // initialValue: widget.id == "" ? null : widget.id,
                              maxLines: null,
                              textInputAction: TextInputAction.next,
                              controller: _contentController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Content',
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ]);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (update) {
              updateData(_titleController.text, _contentController.text,
                  widget.uid, widget.id);
              Navigator.pop(context, "update");
              print('Note successfully saved!');
            } else {
              addData(
                _titleController.text,
                _contentController.text,
                widget.uid,
              ).whenComplete(() => Navigator.pop(context, "add"));
              print('Note successfully added!');
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
