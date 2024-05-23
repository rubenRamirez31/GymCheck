import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/widgets/social/rutina_card.dart';

class VerRutinas extends StatefulWidget {
  final String nick;
  const VerRutinas({super.key, required this.nick});

  @override
  State<VerRutinas> createState() => _VerRutinasState();
}

class _VerRutinasState extends State<VerRutinas> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> rutinasStream = FirebaseFirestore.instance
        .collection("Rutinas")
        .where("nick", isEqualTo: widget.nick)
        .snapshots();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: rutinasStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Algo salio mal intentalo de nuevo"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.data!.docs.map((e) {
                  Workout w = Workout.getFirebaseId(
                    e.id,
                    e.data() as Map<String, dynamic>,
                  );
                  return RutinaCard(workout: w);
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox.shrink()
      ],
    );
  }
}
