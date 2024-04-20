import 'dart:io';
import 'package:intl/intl.dart';

class Post {
  final String id;
  final String userId;
  final String? lugar;
  final String texto;
  final String nick;
  final DateTime? fechaCreacion;
  final String? urlImagen;
  final File? imagen;
  final bool editad;

  Post(
      {required this.userId,
      this.lugar,
      required this.texto,
      required this.nick,
      this.fechaCreacion,
      this.urlImagen,
      this.imagen,
      required this.editad,
      required this.id});

  factory Post.getFirebaseId(String idd, Map json) {
    return Post(
      id: json['id'],
      userId: json['userIdAuth'],
      lugar: json['lugar'],
      texto: json['texto'],
      nick: json['nick'],
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['fechaCreacion']['seconds'] * 1000)
          : null,
      urlImagen: json['URLimagen'],
      imagen: json['imagen'],
      editad: json['editado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId' : userId,
      'lugar' : lugar,
      'texto' : texto,
      'nick' :nick,
      'fechaCreacion' : fechaCreacion,
      'urlImagen' : urlImagen,
      'imagen' : imagen,
      'editad' : editad
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userIdAuth'],
      lugar: json['lugar'],
      texto: json['texto'],
      nick: json['nick'],
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['fechaCreacion']['seconds'] * 1000)
          : null,
      urlImagen: json['URLimagen'],
      imagen: json['imagen'],
      editad: json['editado'],
    );
  }
}
