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
// TODO: renkler duzenlecek
//** detail +*/ +home + forgot + register

// TODO: gereksiz printler + comment ler sılınecek
//** tum printler commit yapıldı
//** detail +*/ +register + forgot+home
//!!! commıtler ıncelenedcek

// TODO: hata alınabılecek yerler test edılecek

// !!! TODO: bos data eklenıyor

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
          // buttonColor: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple[200],
          )),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
