import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikeCount extends StatefulWidget {
  final String postId;
  const LikeCount({super.key, required this.postId});

  @override
  State<LikeCount> createState() => _LikeCountState();
}

class _LikeCountState extends State<LikeCount> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Publicaciones")
          .doc(widget.postId)
          .collection("favoritos")
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
