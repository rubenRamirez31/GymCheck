import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/social/comentario.dart';

class Notificacion {
  String? id;
  String remitente;
  String destinatario;
  String contenido;
  DateTime fecha;
  String referencia;
  bool visto;
  String tipo;

  Notificacion(
      {this.id,
      required this.remitente,
      required this.destinatario,
      required this.fecha,
      required this.referencia,
      required this.visto,
      required this.contenido,
      required this.tipo});

  factory Notificacion.getFirebaseId(String idd, Map json) {
    return Notificacion(
        id: idd,
        remitente: json['remitente'],
        destinatario: json['destinatario'],
        contenido: json['contenido'],
        fecha: (json['fecha'] as Timestamp).toDate(),
        referencia: json['referencia'],
        visto: json['visto'],
        tipo: json['tipo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'remitente': remitente,
      'destinatario': destinatario,
      'fecha': fecha,
      'referencia': referencia,
      'visto': visto
    };
  }
}
