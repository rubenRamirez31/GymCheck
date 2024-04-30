class MetaPrincipal {
  
  String tipo;
  String tipoMeta;
  String tipoRutina;
  Map<String, dynamic> datosCorporalesIniciales;
  Map<String, dynamic> datosCorporalesFinales;
  Map<String, dynamic> datosCorporalesVariables; // Nuevos datos corporales variables
  DateTime fechaInicio;
  DateTime fechaFinalizacion;
  bool finalizada;
  bool activa; // Nuevo campo activa
  int duracion;
  String informacionMeta;
  Map<String, dynamic> macros; // Nuevos valores mínimos
  Map<String, dynamic> metasDiarias; // Nuevos valores mínimos
  
  MetaPrincipal({

    required this.tipo,
    required this.tipoMeta,
    required this.tipoRutina,
    required this.datosCorporalesIniciales,
    required this.datosCorporalesFinales,
    required this.datosCorporalesVariables,
    required this.fechaInicio,

    required this.fechaFinalizacion,
    required this.finalizada,
    required this.activa,
    required this.duracion,
    required this.informacionMeta,
    required this.macros,
    required this.metasDiarias,

  });

  factory MetaPrincipal.fromJson(Map<String, dynamic> json) {
    return MetaPrincipal(

      tipo: json['tipo'],
      tipoMeta: json['tipoMeta'],
      tipoRutina: json['tipoRutina'],
      datosCorporalesIniciales: json['datosCorporalesIniciales'],
      datosCorporalesFinales: json['datosCorporalesFinales'],
      datosCorporalesVariables: json['datosCorporalesVariables'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
   
      fechaFinalizacion: DateTime.parse(json['fechaFinalizacion']),
      finalizada: json['finalizada'],
      activa: json['activa'],
      duracion: json['duracion'],
      informacionMeta: json['informacionMeta'],
      macros: json['macros'],
      metasDiarias: json['metasDiarias'],
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
     
      'tipo': tipo,
      'tipoMeta': tipoMeta,
      'tipoRutina': tipoRutina,
      'datosCorporalesIniciales': datosCorporalesIniciales,
      'datosCorporalesFinales': datosCorporalesFinales,
      'datosCorporalesVariables': datosCorporalesVariables,
      'fechaInicio': fechaInicio.toIso8601String(),
     
      'fechaFinalizacion': fechaFinalizacion.toIso8601String(),
      'finalizada': finalizada,
      'activa': activa,
      'duracion': duracion,
      'informacionMeta': informacionMeta,
     
      'macros': macros,
      'metasDiarias': metasDiarias,
    };
  }
}
