// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_daily_goals.dart';
import 'package:gym_check/src/services/nutritional_tracking_service.dart';

class CreateMatricesPage extends StatefulWidget {
  final String tipoMeta;
  final Map<String, dynamic> datosCorporales;

  const CreateMatricesPage(
      {Key? key, required this.tipoMeta, required this.datosCorporales})
      : super(key: key);

  @override
  _CreateMatricesPageState createState() => _CreateMatricesPageState();
}

class _CreateMatricesPageState extends State<CreateMatricesPage> {
  late Map<String, double> macros; // Hold calculated macros
  double proteinas = 0;
  double grasas = 0;
  double carbo = 0;

  @override
  void initState() {
    super.initState();
    macros = calcularMacros(widget.tipoMeta, widget.datosCorporales);
    //proteinas = macros['proteinas'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Macros',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu ingesta diaria:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildMacroRow('Proteínas', '${macros['proteinas']} g'),
            _buildMacroRow('Carbohidratos', '${macros['carbohidratos']} g'),
            _buildMacroRow('Grasas', '${macros['grasas']} g'),
            CustomButton(
                text: "Guardar Macros",
                onPressed: () {
                  _saveSettings();
                })
          ],
        ),
      ),

      //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => SelectDailyGoals(
      //                   macros: macros,
      //                   tipoMeta: widget.tipoMeta,
      //                 )),
      //       );
      //     },
      //     backgroundColor: const Color(0xff0C1C2E),
      //     child: const Icon(Icons.arrow_forward, color: Colors.white),
      //   ),
    );
  }

  Widget _buildMacroRow(String macro, String cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 83, 83, 83),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                macro + ':',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                cantidad,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSettings() async {
    final newMacros = {
      'macros': [macros['proteinas'], macros['carbohidratos'], macros['grasas']]
    };

    await NutritionalService.updateTrackingData(context, newMacros);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Fondo negro
          title: const Text(
            'Macros creadas',
            style: TextStyle(color: Colors.white), // Letras blancas
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tu macros han sido guardadas',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Reinicia la página
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const PrincipalPage(
                        initialPageIndex: 2,
                      ),
                    ),
                  );
                },
                child: const Text('Aceptar',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Error al guardar')),);
  }

  Map<String, double> calcularMacros(
      String tipoMeta, Map<String, dynamic> datosCorporales) {
    final rangosValores = {
      'Pérdida de peso': {
        'proteinas': {'min': 1.2, 'max': 2.0},
        'carbohidratos': {'min': 40, 'max': 55},
        'grasas': {'min': 20, 'max': 30}
      },
      'Aumento de masa muscular': {
        'proteinas': {'min': 1.6, 'max': 2.2},
        'carbohidratos': {'min': 45, 'max': 60},
        'grasas': {'min': 25, 'max': 35}
      },
      'Definición muscular': {
        'proteinas': {'min': 1.8, 'max': 2.4},
        'carbohidratos': {'min': 35, 'max': 50},
        'grasas': {'min': 20, 'max': 30}
      },
      'Mantener peso': {
        'proteinas': {'min': 1.0, 'max': 1.5},
        'carbohidratos': {'min': 45, 'max': 60},
        'grasas': {'min': 20, 'max': 35}
      },
    };

    final tdee = datosCorporales['tdee'];

    final rangoValoresMeta = rangosValores[tipoMeta];
    final proteinaMin = rangoValoresMeta!['proteinas']!['min'];
    final carbohidratosMin = rangoValoresMeta['carbohidratos']!['min'];
    final grasasMin = rangoValoresMeta['grasas']!['min'];

    final macros = {
      'proteinas': (proteinaMin! * datosCorporales['peso']) as double,
      'carbohidratos': (((carbohidratosMin! / 100) * tdee / 4)),
      'grasas': (((grasasMin! / 100) * tdee / 9)),
    };

    // Código existente

    // Redondear los valores a 2 decimales
    final roundedMacros = {
      'proteinas': double.parse((macros['proteinas']!).toStringAsFixed(2)),
      'carbohidratos':
          double.parse((macros['carbohidratos']!).toStringAsFixed(2)),
      'grasas': double.parse((macros['grasas']!).toStringAsFixed(2)),
    };

    return roundedMacros;
  }
}
