import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  String fName = "";
  String lName = "";
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool obscurepassword = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          // elevation: 0,
        ),
        body: user.emailVerified
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user.email.toString()),
                  const Text("onaylanmıs"),
                  const SizedBox(
                    height: 10,
                  ),
                  //password
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
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: _passwordController,
                            obscureText: obscurepassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Password',
                              hintText: '******',
                              suffixIcon: GestureDetector(
                                onTap: showPassword,
                                child: Icon(
                                  obscurepassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //confirm password
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
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: _confirmPasswordController,
                            obscureText: obscurepassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Confirm Password',
                              hintText: '******',
                              suffixIcon: GestureDetector(
                                onTap: showPassword,
                                child: Icon(
                                  obscurepassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (_passwordController.text.trim() ==
                              _confirmPasswordController.text &&
                          _passwordController.text != null &&
                          _passwordController != "") {
                        try {
                          await user
                              .updatePassword(_passwordController.text.trim());

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Text("sifre yenılerndi"),
                              );
                            },
                          );
                          _passwordController.text = "";
                          _confirmPasswordController.text = "";
                        } on FirebaseAuthException catch (e) {
                          // print("hata :  ${e}");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text("Error: ${e.message}"),
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Text("sifreler uyusmuyor"),
                            );
                          },
                        );
                      }
                    },
                    color: Colors.deepPurple,
                    child: const Text("sifre yenıle"),
                  ),
                ],
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      // TODO:
                      'şifre yanılemek icin email onaylanmıs olmalı',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Click the send button to verify your email address.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      try {
                        await user.sendEmailVerification();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Text(
                                  "Verification code sent to your e-mail address"),
                            );
                          },
                        );
                      } on FirebaseAuthException catch (e) {
                        // print("hata :  ${e}");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Error: ${e.message}"),
                            );
                          },
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(e.message.toString()),
                            );
                          },
                        );
                      }
                    },
                    child: const Text("send email"),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
      ),
    );
  }

  Future getVerifyCode() async {
    //  final verifyCode=  user.ve
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

  showPassword() {
    setState(() {
      obscurepassword = !obscurepassword;
    });
  }
}
