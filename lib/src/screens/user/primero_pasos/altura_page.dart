// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/screens/user/primero_pasos/first_photo_page.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';

class AlturaPage extends StatefulWidget {
  const AlturaPage({Key? key}) : super(key: key);

  @override
  _AlturaPageState createState() => _AlturaPageState();
}

class _AlturaPageState extends State<AlturaPage> {
  double _selectedAltura = 150; // Altura inicial

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
                "Selecciona tu Altura",
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
               Text(
                "Selecciona tu altura en centímetros usando el slider",
                style: AppTheme.bodySmall,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200, // Aumenta la altura del slider
                    child: Slider(
                      value: _selectedAltura,
                      min: 100,
                      max: 250,
                      divisions: 150,
                      onChanged: (value) {
                        setState(() {
                          _selectedAltura = value;
                        });
                      },
                      label: _selectedAltura.round().toString() + " cm", // Mostrar la altura en cm
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${_selectedAltura.round()} cm', // Mostrar la altura en cm
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
          _agregarAltura(context);
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Future<void> _agregarAltura(BuildContext context) async {
    try {
      double valor = _selectedAltura; // Utiliza el valor seleccionado
      String tipo = "altura";

      RegistroFisico bodyData = RegistroFisico(tipo: tipo, valor: valor);

      String coleccion = "Registro-Corporal";

      await PhysicalDataService.addData(context, coleccion, bodyData.toJson());
      Map<String, dynamic> userData = {
        'primeros_pasos': 5,
      };

      await UserService.updateUser(userData, context);

       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => const FirstPhotoPage()),
       );
    } catch (error) {
      print('Error: $error');
    }
  }
}
