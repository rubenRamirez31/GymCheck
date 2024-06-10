import 'dart:ui';

class Reminder {
  int idRecordar;
  String? day;
  String title;
  String tipo;
  String? modelo;
  String description;
  DateTime startTime;
  DateTime endTime;
  bool terminado;
  Map<String, dynamic>? datosObjeto;
  Color color;
  String? objetoID;

  List<int> repeatDays; // Agregar lista de días de repetición

  Reminder({
    this.day,
    this.datosObjeto,
    required this.idRecordar,
    required this.title,
    required this.tipo,
    this.modelo,
    required this.description,
    required this.terminado,
    required this.startTime,
    required this.endTime,
    required this.color, // Incluimos el color en el constructor
    this.objetoID, // Campo de tipo String opcional

    List<int>? repeatDays, // Lista opcional de días de repetición
  }) : repeatDays =
            repeatDays ?? []; // Asignar una lista vacía si no se proporciona

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      idRecordar: json['idRecordar'],
      day: json['day'],
      terminado: json['terminado'],
      title: json['title'],
      tipo: json['tipo'],
      datosObjeto: json['datosObjeto'],
      modelo: json['modelo'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      color:
          Color(json['color']), // Convertimos el valor del color de int a Color
      objetoID: json['objetoID'], // Campo de tipo String opcional
      repeatDays: List<int>.from(json['repeatDays'] ??
          []), // Convertir lista de JSON a lista de enteros
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRecordar': idRecordar,
      'datosObjeto': datosObjeto,
      'day': day,
      'terminado': terminado,
      'modelo': modelo,
      'tipo': tipo,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'color': color.value, // Convertimos el Color a su valor entero
      'objetoID': objetoID, // Campo de tipo String opcional

      'repeatDays': repeatDays, // Convertir lista de enteros a JSON
    };
  }

  Reminder clone() {
    return Reminder(
      idRecordar: idRecordar,
      day: day,
      datosObjeto: datosObjeto,
      terminado: terminado,
      modelo: modelo,
      tipo: tipo,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      color: color, // Convertimos el valor entero a Color
      objetoID: objetoID,

      repeatDays: repeatDays != null ? List<int>.from(repeatDays!) : null,
    );
  }
}
