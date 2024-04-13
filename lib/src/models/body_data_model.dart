class BodyData {
  final double? peso;
  final double? grasaCorporal;
  final double? circunferenciaCintura;
  final double? altura;
  final DateTime? fecha;

  BodyData({
    this.peso,
    this.grasaCorporal,
    this.circunferenciaCintura,
    this.altura,
    this.fecha,
  });

  factory BodyData.fromJson(Map<String, dynamic> json) {
    return BodyData(
      peso: json['peso'] as double?,
      grasaCorporal: json['grasaCorporal'] as double?,
      circunferenciaCintura: json['circunferenciaCintura'] as double?,
      altura: json['altura'] as double?,
      fecha: json['fechaCreacion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fechaCreacion']['seconds'] * 1000)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peso': peso,
      'grasaCorporal': grasaCorporal,
      'circunferenciaCintura': circunferenciaCintura,
      'altura': altura,
      'fecha': fecha,
    };
  }
}
