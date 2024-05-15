import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
class Food {
  String? id; // ID del documento (no requerido, se generará automáticamente)
  String urlImage; // URL de la imagen del alimento
  String name; // Nombre del alimento
  String description; // Descripción del alimento
  List<String> ingredients; // Lista de ingredientes del alimento
  String type; // Tipo de alimento (desayuno, comida, merienda, bebida, etc.)
  String preparation; // Instrucciones de preparación del alimento
  Map<String, int> nutrients; // Información sobre los macronutrientes del alimento

  // Constructor
  Food({
    this.id,
    required this.urlImage,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.type,
    required this.preparation,
    required this.nutrients,
  });

  // Método para convertir un mapa en una instancia de Food
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      urlImage: map['urlImage'],
      name: map['name'],
      description: map['description'],
      ingredients: List<String>.from(map['ingredients']),
      type: map['type'],
      preparation: map['preparation'],
      nutrients: Map<String, int>.from(map['nutrients']),
    );
  }

  // Método para convertir una instancia de Food en un mapa
  Map<String, dynamic> toMap() {
    return {
      'urlImage': urlImage,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'type': type,
      'preparation': preparation,
      'nutrients': nutrients,
    };
  }

  // Método para convertir un JSON en una instancia de Food
  factory Food.fromJson(String json) => Food.fromMap(jsonDecode(json));

  // Método para convertir una instancia de Food en JSON
  String toJson() => jsonEncode(toMap());


// Método para crear una instancia de Food desde un DocumentSnapshot de Firestore
factory Food.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  data['id'] = doc.id;
  return Food.fromMap(data);
}

}
