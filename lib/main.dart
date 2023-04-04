import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:not_defteri/auth/main_page.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.grey[300],
        dialogBackgroundColor: Colors.grey[200],
        primaryColor: Colors.white,
        primaryColorDark: Colors.black,
        buttonColor: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
