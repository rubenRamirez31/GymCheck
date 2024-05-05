import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentCount extends StatefulWidget {
    final String postId;
  const CommentCount({super.key, required this.postId});

  @override
  State<CommentCount> createState() => _CommentCountState();
}

class _CommentCountState extends State<CommentCount> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Publicaciones")
          .doc(widget.postId)
          .collection("comentarios")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int likeCount = snapshot.data?.docs.length ?? 0;
          return Text(
            '$likeCount',
          );
        }
      },
    );
  }
}