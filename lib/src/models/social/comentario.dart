import 'package:cloud_firestore/cloud_firestore.dart';

class Comentario {
  String? id;
  String correo;
  DateTime fechaCreacion;
  String comentario;
  String userId;

  Comentario(
      {this.id,
      required this.correo,
      required this.fechaCreacion,
      required this.comentario,
      required this.userId});

  factory Comentario.getFirebase(Map json) {
    return Comentario(
        id: json['id'],
        correo: json['correo'],
        fechaCreacion: json['fecha'],
        comentario: json['comentario'],
        userId: json['userIdAuth']);
  }

  factory Comentario.getFirebaseId(String idd, Map json) {
    return Comentario(
        id: idd,
        correo: json['correo'],
        fechaCreacion: (json['fecha'] as Timestamp).toDate(),
        comentario: json['comentario'],
        userId: json['userIdAuth']);
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'fecha': fechaCreacion,
      'comentario': comentario,
      'userIdAuth': userId
    };
  }
}
