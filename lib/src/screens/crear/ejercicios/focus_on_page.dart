import 'package:flutter/material.dart';

class FocusedOnPage extends StatefulWidget {
  final String muscle;

  const FocusedOnPage({Key? key, required this.muscle}) : super(key: key);

  @override
  _FocusedOnPageState createState() => _FocusedOnPageState();
}

class _FocusedOnPageState extends State<FocusedOnPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [Text(widget.muscle, style: TextStyle(color: Colors.amber))],
        ),
      ),
    );
  }
}
