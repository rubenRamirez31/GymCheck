import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  TransparentButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white),
        primary: Colors.white,
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Text(text),
    );
  }
}