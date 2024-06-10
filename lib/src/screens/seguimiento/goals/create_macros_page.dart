// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_daily_goals.dart';
import 'package:gym_check/src/services/nutritional_tracking_service.dart';

class CreateMacrosPage extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const CreateMacrosPage(
      {Key? key, required this.datosUsuario})
      : super(key: key);

  @override
  _CreateMacrosPageState createState() => _CreateMacrosPageState();
}


class _CreateMacrosPageState extends State<CreateMacrosPage> {
  late Map<String, double> macros; // Hold calculated macros
  double proteinas = 0;
  double grasas = 0;
  double carbo = 0;

  @override
  void initState() {
    super.initState();
    macros = calcularMacros(widget.datosUsuario);
    print(macros);
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
Map<String, double> calcularMacros(Map<String, dynamic> datosUsuario) {
  double peso = datosUsuario['peso'];
  double altura = datosUsuario['altura'];
  int edad = datosUsuario['edad'];
  String sexo = datosUsuario['sexo'];
  String nivelActividad = datosUsuario['nivelActividad'];
  String objetivo = datosUsuario['objetivo'];

  // Calculamos el TMB
  double tmb;
  if (sexo.toLowerCase() == 'masculino') {
    tmb = 10 * peso + 6.25 * altura - 5 * edad + 5;
  } else {
    tmb = 10 * peso + 6.25 * altura - 5 * edad - 161;
  }

  // Ajuste por nivel de actividad
  double factorActividad;
  switch (nivelActividad.toLowerCase()) {
    case 'sedentario':
      factorActividad = 1.2;
      break;
    case 'ligero':
      factorActividad = 1.375;
      break;
    case 'moderado':
      factorActividad = 1.55;
      break;
    case 'activo':
      factorActividad = 1.725;
      break;
    case 'muy activo':
      factorActividad = 1.9;
      break;
    default:
      factorActividad = 1.2; // valor por defecto
  }

  double tdee = tmb * factorActividad;

  // Ajuste por objetivo
  switch (objetivo.toLowerCase()) {
    case 'pérdida de peso':
      tdee -= 500;
      break;
    case 'aumento de masa muscular':
      tdee += 500;
      break;
    case 'definición muscular':
      tdee -= 200; // Pequeño déficit calórico para quemar grasa y mantener músculo
      break;
    case 'mantener peso':
      // No hay ajuste necesario para mantener el peso
      break;
  }

  // Distribución de macros
  double caloriasProteinas = tdee * 0.25;
  double caloriasCarbohidratos = tdee * 0.55;
  double caloriasGrasas = tdee * 0.20;

  double gramosProteinas = caloriasProteinas / 4;
  double gramosCarbohidratos = caloriasCarbohidratos / 4;
  double gramosGrasas = caloriasGrasas / 9;

  // Redondear los valores a 2 decimales
  final roundedMacros = {
    'proteinas': double.parse(gramosProteinas.toStringAsFixed(2)),
    'carbohidratos': double.parse(gramosCarbohidratos.toStringAsFixed(2)),
    'grasas': double.parse(gramosGrasas.toStringAsFixed(2)),
  };

  return roundedMacros;
}

}



