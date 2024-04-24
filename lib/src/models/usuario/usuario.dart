import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? docId;
  String primerNombre = "";
  String segundoNombre = "";
  String apellidos = "";
  String genero = "";
  String nick = "";
  String correo = "";
  String fotoPerfil = "";
  String idAuth = "";
  int? primerosPasos;
  DateTime? fechaCreacion;
  bool? verificado;

  Usuario(
      {this.docId,
      required this.primerNombre,
      required this.segundoNombre,
      required this.apellidos,
      required this.genero,
      required this.nick,
      required this.correo,
      required this.fotoPerfil,
      required this.idAuth,
      this.primerosPasos,
      this.fechaCreacion,
      this.verificado});

  factory Usuario.getFirebaseId(String idd, Map json) {
    return Usuario(
      docId: idd,
      primerNombre: json['primer_nombre'],
      segundoNombre: json['segundo_nombre'],
      apellidos: json['apellios'],
      genero: json['genero'],
      nick: json['nick'],
      correo: json['email'],
      fotoPerfil: json['urlImagen'],
      idAuth: json['userIdAuth'],
      primerosPasos: json['primeros_pasos'],
      fechaCreacion: (json['fechaCreacion'] as Timestamp).toDate(),
      verificado: json['verificado'],
    );
  }
}
