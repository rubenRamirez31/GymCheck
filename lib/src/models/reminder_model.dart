import 'dart:ui';

class Reminder {
  String? day;
  String? routineName;
  String? primaryFocus;
  String? secondaryFocus;
  String title;
  String tipo;
  String description;
  DateTime startTime;
  DateTime endTime;

  Color color; // Nuevo campo para el color
  String? workoutID; // Nuevo campo de tipo String opcional
  String? dietID; // Nuevo campo de tipo String opcional

  Reminder({
    this.day,
    required this.title,
    required this.tipo,
    required this.description,
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
      day: json['day'],
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
      'day': day,
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
