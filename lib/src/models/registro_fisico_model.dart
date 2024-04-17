import 'dart:convert';

class RegistroFisico {
   String tipo;
   double valor ;

  RegistroFisico({
    required this.tipo,
    required this.valor,
  });


Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'valor': valor,
    
    };
  }
}
