import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Caja de comentarios'),
      ),
    );
  }
}
