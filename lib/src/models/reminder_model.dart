import 'dart:ui';

class Reminder {
  int? idRecordar;
  String? day;
  String? routineName;
  String? primaryFocus;
  String? secondaryFocus;
  String title;
  String tipo;
  String description;
  DateTime startTime;
  DateTime endTime;
  bool terminado;

  Color color; 
  String? workoutID; 
  String? dietID; 
  
  Reminder({
    this.day,
    this.idRecordar,
    required this.title,
    required this.tipo,
    required this.description,
    required this.terminado,
    this.routineName,
    this.primaryFocus,
    this.secondaryFocus,
    required this.startTime,
    required this.endTime,
    required this.color, // Incluimos el color en el constructor
    this.workoutID, // Campo de tipo String opcional
    this.dietID, // Campo de tipo String opcional

  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      idRecordar: json['idRecordar'],
      day: json['day'],
      terminado: json['terminado'],
      title: json['title'],
      tipo: json['tipo'],
      description: json['description'],
      routineName: json['routineName'],
      primaryFocus: json['primaryFocus'],
      secondaryFocus: json['secondaryFocus'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),

      color:
          Color(json['color']), // Convertimos el valor del color de int a Color
      workoutID: json['workoutID'], // Campo de tipo String opcional
      dietID: json['dietID'], // Campo de tipo String opcional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRecordar': idRecordar,
      'day': day,
      'terminado': terminado,
      'tipo': tipo,
      'title': title,
      'description': description,
      'routineName': routineName,
      'primaryFocus': primaryFocus,
      'secondaryFocus': secondaryFocus,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),

      'color': color.value, // Convertimos el Color a su valor entero
      'workoutID': workoutID, // Campo de tipo String opcional
      'dietID': dietID, // Campo de tipo String opcional
    };
  }
}
