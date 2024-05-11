import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String? id; // ID del documento (opcional)
  String name; // Nombre del ejercicio
  String primaryFocus; // Enfoque principal del ejercicio
  String secondaryFocus; // Enfoque secundario del ejercicio
  String description; // Descripción del ejercicio
  List<String> equipment; // Lista de equipos utilizados
  String representativeImageLink; // Enlace a la imagen representativa
  String videoLink; // Enlace al video del ejercicio
  Map<String, int> focusLevels; // Niveles de enfoque por grupo muscular
  List<String> tags; // Etiquetas que describen el ejercicio

  Exercise({
    this.id, // El ID puede ser opcional
    required this.name,
    required this.primaryFocus,
    required this.secondaryFocus,
    required this.description,
    required this.equipment,
    required this.representativeImageLink,
    required this.videoLink,
    required this.focusLevels,
    required this.tags,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id, // Asignar el ID del documento
      name: data['name'],
      primaryFocus: data['primaryFocus'],
      secondaryFocus: data['secondaryFocus'],
      description: data['description'],
      equipment: List<String>.from(data['equipment'] ?? []),
      representativeImageLink: data['representativeImageLink'],
      videoLink: data['videoLink'],
      focusLevels: Map<String, int>.from(data['focusLevels'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'], // Asignar el ID del JSON (si está presente)
      name: json['name'] ?? '',
      primaryFocus: json['primaryFocus'] ?? '',
      secondaryFocus: json['secondaryFocus'] ?? '',
      description: json['description'] ?? '',
      equipment: List<String>.from(json['equipment'] ?? []),
      representativeImageLink: json['representativeImageLink'] ?? '',
      videoLink: json['videoLink'] ?? '',
      focusLevels: Map<String, int>.from(json['focusLevels'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'primaryFocus': primaryFocus,
      'secondaryFocus': secondaryFocus,
      'description': description,
      'equipment': equipment,
      'representativeImageLink': representativeImageLink,
      'videoLink': videoLink,
      'focusLevels': focusLevels,
      'tags': tags,
    };
  }
}
