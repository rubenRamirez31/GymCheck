import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? docId;
  String? primerNombre = "";
  String? segundoNombre = "";
  String? apellidos = "";
  String? genero = "";
  String nick = "";
  String correo = "";
  String? fotoPerfil = "";
  String idAuth = "";
  int? primerosPasos;
  DateTime? fechaCreacion;
  bool? verificado;

  Usuario(
      {this.docId,
       this.primerNombre,
       this.segundoNombre,
       this.apellidos,
       this.genero,
      required this.nick,
      required this.correo,
       this.fotoPerfil,
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

  Map<String, dynamic> toJson() {
    return {
      'primer_nombre' : primerNombre,
      'segundo_nombre' : segundoNombre,
      'apellidos' : apellidos,
      'genero' : genero,
      'nick' :nick,
      'email' : correo,
      'urlImagen' :fotoPerfil,
      'userIdAuth' : idAuth,
      'primeros_pasos' : primerosPasos,
      'fechaCreacion' : fechaCreacion,
      'verificado' : verificado
    };
  }
}
