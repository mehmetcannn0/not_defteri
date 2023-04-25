import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            child: Text('hesabı ve hesaba aıt verılerı sılme'),
          ),
        ),
      ),
    );
  }
}
