// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/user/primero_pasos/peso_page.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:numberpicker/numberpicker.dart';

class EdadPage extends StatefulWidget {
  const EdadPage({super.key});

  @override
  State<EdadPage> createState() => _EdadPageState();
}

class _EdadPageState extends State<EdadPage> {
  int _selectedEdad = 0;
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
                "Selecciona tu Edad",
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text("Selecciona tu edad usando el selector",
                  style: AppTheme.bodySmall),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 200,
                      child: NumberPicker(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        selectedTextStyle:
                            const TextStyle(color: Colors.white, fontSize: 34),
                        value: _selectedEdad.toInt(),
                        minValue: 0,
                        maxValue: 100,
                        step: 1,
                        axis: Axis.vertical, // Opcional: Horizontal
                        onChanged: (value) {
                          setState(() {
                            _selectedEdad = value.toInt();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _agregarEdad(context);
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Future<void> _agregarEdad(BuildContext context) async {
    try {
      Map<String, dynamic> userData = {
        'primeros_pasos': 3,
        'edad': _selectedEdad
      };

      await updateUser(userData, context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PesoPage()));
      // await UserService.updateUser(globales.idAuth, user);
      await PhysicalDataService.createPhysicalData(context);

      //Navigator.pushNamed(context, '/first_photo');
    } catch (error) {
      print('Error: $error');
    }
  }
}
