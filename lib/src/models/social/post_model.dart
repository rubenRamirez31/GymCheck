import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String userId;
  String? lugar;
  String? texto;
  String nick;
  DateTime? fechaCreacion;
  String? urlImagen;
  bool editad;

  Post(
      {required this.userId,
      this.lugar,
      this.texto,
      required this.nick,
      this.fechaCreacion,
      this.urlImagen,
      required this.editad,
      this.id});

  factory Post.getFirebaseId(String idd, Map json) {
    return Post(
      id: idd,
      userId: json['userIdAuth'],
      lugar: json['lugar'],
      texto: json['texto'],
      nick: json['nick'],
      fechaCreacion: (json['fechaCreacion'] as Timestamp).toDate(),
      urlImagen: json['urlImagen'],
      editad: json['editado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userIdAuth': userId,
      'lugar': lugar,
      'texto': texto,
      'nick': nick,
      'fechaCreacion': fechaCreacion,
      'urlImagen': urlImagen,
      'editado': editad
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userIdAuth'],
      lugar: json['lugar'],
      texto: json['texto'],
      nick: json['nick'],
      fechaCreacion: (json['fechaCreacion'] as Timestamp).toDate(),
      urlImagen: json['URLimagen'],
      editad: json['editado'],
    );
  }
}
