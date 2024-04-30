class MetaDiaria {
  String tipo; // Diaria
  bool activaEnDia; // para sacar las metas activas incia como true
  bool seleccionada; // si la meta está seleccionada cuando se creo la meta principal y se eligió la meta diaria(selected)
  String nombre; // Nombre de la meta diaria (consumo de agua, calorías, etc.)
  DateTime horaNotificacion; // Hora de la notificación para la meta diaria se toma de la hora de notificación (reminderTime)
  DateTime fechaCreacion; // cuando se crea el documento
  String mensaje; // por ahora solo poner el nombre de la meta
  double valorMeta; // Valor asignado dependiendo la meta por ejemplo en proteina el valor que debe de consumir
  int valorActual; // Valor actual de la meta diaria
  double porcentajeCumplimiento; // Porcentaje de cumplimiento de la meta diaria

  MetaDiaria({
    required this.tipo,
    required this.activaEnDia,
    required this.seleccionada,
    required this.nombre,
    required this.horaNotificacion,
    required this.fechaCreacion,
    required this.mensaje,
    required this.valorMeta,
    required this.valorActual,
    required this.porcentajeCumplimiento,
  });

  factory MetaDiaria.fromJson(Map<String, dynamic> json) {
    return MetaDiaria(
      tipo: json['tipo'],
      activaEnDia: json['activaEnDia'],
      seleccionada: json['seleccionada'],
      nombre: json['nombre'],
      horaNotificacion: DateTime.parse(json['horaNotificacion']),
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      mensaje: json['mensaje'],
      valorMeta: json['valorMeta'],
      valorActual: json['valorActual'],
      porcentajeCumplimiento: json['porcentajeCumplimiento'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'activaEnDia': activaEnDia,
      'seleccionada': seleccionada,
      'nombre': nombre,
      'horaNotificacion': horaNotificacion.toIso8601String(),
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'mensaje': mensaje,
      'valorMeta': valorMeta,
      'valorActual': valorActual,
      'porcentajeCumplimiento': porcentajeCumplimiento,
    };
  }
}
