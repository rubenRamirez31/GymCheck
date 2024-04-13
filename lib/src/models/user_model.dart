import 'dart:io';

class User {
  final String? id;
  final String? userIdAuth;
  final String? email;
  final String? password;
  final String? nick;
  final bool? verificado;
  final int? primerosPasos;
  final String? urlImagen;
  final DateTime? fechaCreacion;
  final String? primerNombre;
  final String? segundoNombre;
  final String? apellidos;
  final String? genero;
  final File? fotoPerfil;

  User({
    this.id,
    this.userIdAuth,
    this.email,
    this.password,
    this.nick,
    this.verificado,
    this.primerosPasos,
    this.urlImagen,
    this.fechaCreacion,
    this.primerNombre,
    this.segundoNombre,
    this.apellidos,
    this.genero,
    this.fotoPerfil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userIdAuth: json['userIdAuth'],
      email: json['email'],
      password: json['password'],
      nick: json['nick'],
      verificado: json['verificado'],
      primerosPasos: json['primerosPasos'],
      urlImagen: json['urlImagen'],
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fechaCreacion']['seconds'] * 1000)
          : null,
      primerNombre: json['primerNombre'],
      segundoNombre: json['segundoNombre'],
      apellidos: json['apellidos'],
      genero: json['genero'],
      fotoPerfil: json['fotoPerfil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nick': nick,
      'userIdAuth': userIdAuth,
      'verificado': verificado,
      'primerosPasos': primerosPasos,
      'urlImagen': urlImagen,
      'fechaCreacion': fechaCreacion?.toIso8601String(),
      'primerNombre': primerNombre,
      'segundoNombre': segundoNombre,
      'apellidos': apellidos,
      'genero': genero,
      'fotoPerfil': fotoPerfil,
    };
  }
}
