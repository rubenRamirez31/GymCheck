import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  String? id; // ID del documento (se generará automáticamente)
  String name; // Nombre de la rutina
  String urlImagen;
  String nick; // Nombre del usuario que creó la rutina
  bool isPublic; // Indica si la rutina es pública o privada
  String primaryFocus; // Enfoque principal de la rutina
  String secondaryFocus; // Enfoque secundario de la rutina
  String thirdFocus; // Enfoque terciario de la rutina
  String description; // Descripción de la rutina
  String type; // Tipo de rutina (de algún grupo muscular, cardio, etc. Este se coloca manualmente)
  int restBetweenSets; // Descanso entre series en segundos
  List<Map<String, dynamic>> series; // Lista de series en la rutina

  // Constructor
  Workout({
    this.id,
    required this.name,
    required this.urlImagen,
    required this.nick,
    required this.isPublic,
    required this.primaryFocus,
    required this.secondaryFocus,
    required this.thirdFocus,
    required this.description,
    required this.type,
    required this.restBetweenSets,
    required this.series,
  });

  // Método para convertir un mapa en una instancia de Workout
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      urlImagen: map['urlImagen'],
      nick: map['nick'],
      isPublic: map['isPublic'],
      primaryFocus: map['primaryFocus'],
      secondaryFocus: map['secondaryFocus'],
      thirdFocus: map['thirdFocus'],
      description: map['description'],
      type: map['type'],
      restBetweenSets: map['restBetweenSets'],
      series: List<Map<String, dynamic>>.from(map['series']),
    );
  }

  // Método para convertir una instancia de Workout en un mapa
  Map<String, dynamic> toMap() {
    return {
     
      'name': name,
      'urlImagen': urlImagen,
      'nick': nick,
      'isPublic': isPublic,
      'primaryFocus': primaryFocus,
      'secondaryFocus': secondaryFocus,
      'thirdFocus': thirdFocus,
      'description': description,
      'type': type,
      'restBetweenSets': restBetweenSets,
      'series': series,
    };
  }

  
  // Método para convertir un JSON en una instancia de Workout
  factory Workout.fromJson(String json) => Workout.fromMap(jsonDecode(json));

  // Método para convertir una instancia de Workout en JSON
  String toJson() => jsonEncode(toMap());

  // Método para crear una instancia de Workout desde un DocumentSnapshot de Firestore
  factory Workout.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Workout.fromMap(data);
  }
}
