import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
//pdf işlemleri
//https://www.youtube.com/watch?v=3x92z0oHbtY&list=PL_5Icp260H5OvlxSWAsVPmsfJLi182w1N&index=1
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      _pdfViewerKey.currentState?.openBookmarkView();
    });
    print(pickedFile!.path!);
    print(pickedFile);
  }

  Future uploadFile() async {
    print("upload calıstı");
    final path = "files/${pickedFile!.name}";
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    // ref.putFile(file);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("download link : $urlDownload");
    print("upload bitti");
    setState(() {
      uploadTask = null;
    });
    print("upload task temızlendı");
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    "${(100 * progress.roundToDouble())}%",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox(
            height: 50,
          );
        }
      },
    );
  }

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

  Future updateData(String title, String content, String uid, String id) async {
    try {
      final notesRef = db.collection("notes-$uid");
      await notesRef.doc(id).update({
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

  Future getData(String uid, String id) async {
    try {
      final notesRef = db.collection("notes-$uid");
      DocumentSnapshot<Map<String, dynamic>> document =
          await notesRef.doc(id).get();

      _titleController.text = document.data()!["title"];
      _contentController.text = document.data()!["content"];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: const Text("Add"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body:
            // SfPdfViewer.network(
            //   'https://www.africau.edu/images/default/sample.pdf',
            //   key: _pdfViewerKey,
            // ),

            SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
              future: update ? getData(widget.uid, widget.id) : null,
              builder: (BuildContext context, snapshot) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),

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
                                maxLines: null,
                                textInputAction: TextInputAction.next,
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Title',
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
                                maxLines: null,
                                textInputAction: TextInputAction.next,
                                controller: _contentController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Content',
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Text("pdf acılacak"),
                          //pdf upload edıldıkten sonra url alınarak acılmalı
                          // yada yerelde gosterecek onaylanırsa yukleyecek
                          if (pickedFile != null)
                            Container(
                              height: 550,
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: SfPdfViewer.file(
                                    File(pickedFile!.path!),
                                    // SfPdfViewer.network(
                                    //   "https://www.africau.edu/images/default/sample.pdf",
                                    //   key: _pdfViewerKey,
                                    //   // canShowScrollHead: true,
                                  ),
                                ),
                              ),
                            ),
                          ElevatedButton(
                              onPressed: () {
                                selectFile().whenComplete(() {});
                              },
                              child: Text("select file")),
                          ElevatedButton(
                              onPressed:
                                  pickedFile != null ? uploadFile : () {},
                              child: Text("upload file")),
                          const SizedBox(
                            height: 10,
                          ),
                          buildProgress(),
                        ],
                      )
                    ]);
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if (update) {
              updateData(_titleController.text, _contentController.text,
                  widget.uid, widget.id);
              Navigator.pop(context, "update");
            } else {
              addData(
                _titleController.text,
                _contentController.text,
                widget.uid,
              ).whenComplete(() => Navigator.pop(context, "add"));
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
