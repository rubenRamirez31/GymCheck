import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? docId;
  String? primerNombre = "";
  String? segundoNombre = "";
  String? apellidos = "";
  String? genero = "";
  String? nick = "";
  String? correo = "";
  String? fotoPerfil = "";
  String? idAuth = "";
  int? primerosPasos;
  DateTime? fechaCreacion;
  bool? verificado;
  int? edad;
  String? tokenfcm;

  Usuario(
      {this.docId,
      this.primerNombre,
      this.segundoNombre,
      this.apellidos,
      this.genero,
      this.nick,
      this.correo,
      this.fotoPerfil,
      this.idAuth,
      this.primerosPasos,
      this.fechaCreacion,
      this.verificado,
      this.edad,
      this.tokenfcm});

  factory Usuario.getFirebaseId(String idd, Map json) {
    return Usuario(
        docId: idd,
        primerNombre: json['primer_nombre'],
        segundoNombre: json['segundo_nombre'],
        apellidos: json['apellidos'],
        genero: json['genero'],
        nick: json['nick'],
        correo: json['email'],
        fotoPerfil: json['urlImagen'],
        idAuth: json['userIdAuth'],
        primerosPasos: json['primeros_pasos'],
        fechaCreacion: (json['fechaCreacion'] as Timestamp).toDate(),
        verificado: json['verificado'],
        edad: json['edad'], // Asignar el valor del campo de edad si existe
        tokenfcm: json['tokenfcm']);
  }

  Map<String, dynamic> toJson() {
    return {
      'primer_nombre': primerNombre,
      'segundo_nombre': segundoNombre,
      'apellidos': apellidos,
      'genero': genero,
      'nick': nick,
      'email': correo,
      'urlImagen': fotoPerfil,
      'userIdAuth': idAuth,
      'primeros_pasos': primerosPasos,
      'fechaCreacion': fechaCreacion,
      'verificado': verificado,
      'edad': edad, // Agregar campo de edad al JSON si existe
      'tokenfcm' : tokenfcm
    };
  }
}
