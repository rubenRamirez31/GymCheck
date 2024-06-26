import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? docId;
  String? primerNombre;
  String? segundoNombre;
  String? apellidos;
  String? genero;
  String? nick;
  String? correo;
  String? fotoPerfil;
  String? idAuth;
  int? primerosPasos;
  DateTime? fechaCreacion;
  bool? verificado;
  int? edad;
  DateTime? fechaNacimiento;
  String? tokenfcm;
  List<String>? followers;
  List<String>? following;

  Usuario({
    this.docId,
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
    this.fechaNacimiento,
    this.tokenfcm,
    this.followers,
    this.following,
  });

  factory Usuario.fromMap(Map<String, dynamic> map, String docId) {
    return Usuario(
      docId: docId,
      primerNombre: map['primer_nombre'] ?? '',
      segundoNombre: map['segundo_nombre'] ?? '',
      apellidos: map['apellidos'] ?? '',
      genero: map['genero'] ?? '',
      nick: map['nick'] ?? '',
      correo: map['email'] ?? '',
      fotoPerfil: map['urlImagen'] ?? '',
      idAuth: map['userIdAuth'] ?? '',
      primerosPasos: map['primeros_pasos'] ?? 0,
      fechaCreacion: (map['fechaCreacion'] as Timestamp?)?.toDate(),
      verificado: map['verificado'] ?? false,
      fechaNacimiento: (map['fechaNacimiento'] as Timestamp?)?.toDate(),
      edad: map['edad'] ?? 0,
      tokenfcm: map['tokenfcm'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
    );
  }

  factory Usuario.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Usuario(
      docId: snapshot.id,
      primerNombre: data['primer_nombre'] ?? '',
      segundoNombre: data['segundo_nombre'] ?? '',
      apellidos: data['apellidos'] ?? '',
      genero: data['genero'] ?? '',
      nick: data['nick'] ?? '',
      correo: data['email'] ?? '',
      fotoPerfil: data['urlImagen'] ?? '',
      idAuth: data['userIdAuth'] ?? '',
      primerosPasos: data['primeros_pasos'] ?? 0,
      fechaCreacion: (data['fechaCreacion'] as Timestamp?)?.toDate(),
      verificado: data['verificado'] ?? false,
      fechaNacimiento: (data['fechaNacimiento'] as Timestamp?)?.toDate(),
      edad: data['edad'] ?? 0,
      tokenfcm: data['tokenfcm'] ?? '',
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
    );
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
      'fechaNacimiento': fechaNacimiento,
      'edad': edad,
      'tokenfcm': tokenfcm,
      'followers': followers,
      'following': following,
    };
  }
}
