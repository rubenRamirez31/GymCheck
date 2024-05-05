// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/screens/user/primero_pasos/altura_page.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';

class PesoPage extends StatefulWidget {
  const PesoPage({Key? key}) : super(key: key);

  @override
  _PesoPageState createState() => _PesoPageState();
}

class _PesoPageState extends State<PesoPage> {
  double _selectedPeso = 50; // Peso inicial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GradientBackground(
            children: [
              Text(
                "Selecciona tu Peso",
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text(
                "Selecciona tu peso usando el slider",
                style: AppTheme.bodySmall,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200, // Aumenta la altura del slider
                    child: Slider(
                      activeColor: const Color.fromARGB(255, 25, 57, 94),
                      value: _selectedPeso.toDouble(),
                      min: 0,
                      max: 200,
                      divisions: 200,
                      label: '$_selectedPeso Kg',
                      onChanged: (value) {
                        setState(() {
                          _selectedPeso = value.toDouble();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$_selectedPeso Kg',
                    style: const TextStyle(color: Colors.white, fontSize: 24), // Aumenta el tamaño del texto
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _agregarPeso(context);
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Future<void> _agregarPeso(BuildContext context) async {
    try {
      double valor = _selectedPeso; // Utiliza el valor seleccionado
      String tipo = "peso";

      RegistroFisico bodyData = RegistroFisico(tipo: tipo, valor: valor);

      String coleccion = "Registro-Corporal";

      await PhysicalDataService.addData(context, coleccion, bodyData.toJson());
      Map<String, dynamic> userData = {
        'primeros_pasos': 4,
      };

      await updateUser(userData, context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlturaPage()),
      );
    } catch (error) {
      print('Error: $error');
    }
  }
}
