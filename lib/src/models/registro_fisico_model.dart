import 'dart:convert';

class RegistroFisico {
   String tipo;
   double valor ;
   String? ejercicio;
   String? equipamiento;

  RegistroFisico({
    required this.tipo,
    required this.valor,
    this.ejercicio,
    this.equipamiento
  });


Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'valor': valor,
      'ejercicio': ejercicio,
      'equipamiento': equipamiento,
    
    };
  }
}
