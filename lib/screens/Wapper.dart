import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter Chat",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade700
        ),
        child: Center(
          child: Text("Wrapper"),
        ),
      ),
    );
  }
}
