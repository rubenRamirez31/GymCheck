import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Nick extends StatelessWidget {
  final String userId;

  const Nick({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Usuarios')
          .where("userIdAuth", isEqualTo: userId)
          .get()
          .then((snapshot) => snapshot.docs.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final nick = userData['nick'] as String?;

        return Text(
          nick ?? 'Nick no disponible',
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
