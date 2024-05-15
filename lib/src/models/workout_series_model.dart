import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutSeries {
  String? id; // ID del documento (se generará automáticamente)
  String name; // Nombre de la serie
  String nick; // Nombre del usuario que creó la serie
  bool isPublic; // Indica si la serie es pública o privada
  String primaryFocus; // Enfoque principal de la serie
  String secondaryFocus; // Enfoque secundario de la serie
  String description; // Descripción de la serie
  String type; // Tipo de serie (serie, biseries, triseries, drop sets, pyramid sets)
  int sets; // Número de sets de la serie
  int restBetweenSets; // Descanso entre sets en segundos
  List<Map<String, dynamic>> exercises; // Lista de ejercicios en la serie
  Map<String, int> focusLevels; // Niveles de enfoque por grupo muscular

  WorkoutSeries({
    this.id,
    required this.name,
    required this.nick,
    required this.isPublic,
    required this.primaryFocus,
    required this.secondaryFocus,
    required this.description,
    required this.type,
    required this.sets,
    required this.restBetweenSets,
    required this.exercises,
        required this.focusLevels,
  });

  factory WorkoutSeries.fromJson(String json) =>
      WorkoutSeries.fromMap(jsonDecode(json));

  factory WorkoutSeries.fromMap(Map<String, dynamic> map) {
    return WorkoutSeries(
      id: map['id'],
      name: map['name'],
      nick: map['nick'],
      isPublic: map['isPublic'],
      primaryFocus: map['primaryFocus'],
      secondaryFocus: map['secondaryFocus'],
      description: map['description'],
      type: map['type'],
      sets: map['sets'],
      restBetweenSets: map['restBetweenSets'],
      exercises: List<Map<String, dynamic>>.from(map['exercises'] ?? []),
       focusLevels: Map<String, int>.from(map['focusLevels'] ?? {}),
    );
  }

  factory WorkoutSeries.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WorkoutSeries.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nick': nick,
      'isPublic': isPublic,
      'primaryFocus': primaryFocus,
      'secondaryFocus': secondaryFocus,
      'description': description,
      'type': type,
      'sets': sets,
      'restBetweenSets': restBetweenSets,
      'exercises': exercises,
      'focusLevels': focusLevels,
    };
  }

  String toJson() => jsonEncode(toMap());
}
