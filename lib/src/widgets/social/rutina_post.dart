import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/workout_model.dart';

class RutinaLoader extends StatelessWidget {
  final String idRutina;
  final Widget Function(Workout workout) builder;

  const RutinaLoader({Key? key, required this.idRutina, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('Rutinas').doc(idRutina).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Mapear los datos obtenidos de Firestore a un objeto Workout
          Workout workout = Workout.fromFirestore(snapshot.data!);

          // Llamar al builder con los datos de la rutina
          return builder(workout);
        }
      },
    );
  }
}
