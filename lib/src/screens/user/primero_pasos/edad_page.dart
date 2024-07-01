import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/user/primero_pasos/peso_page.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'dart:math';

class EdadPage extends StatefulWidget {
  const EdadPage({super.key});

  @override
  State<EdadPage> createState() => _EdadPageState();
}

class _EdadPageState extends State<EdadPage> {
  DateTime _selectedDate = DateTime.now();

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GradientBackground(
            children: [
              Text(
                "Selecciona tu Fecha de Nacimiento",
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text("Selecciona tu fecha de nacimiento usando el selector",
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
                    Container(
                     // color: Color.fromARGB(255, 18, 18, 18),
                      height: 250,
                      
                      child: ScrollDatePicker(
                        selectedDate: _selectedDate,
                        locale: Locale('es'),
                        onDateTimeChanged: (DateTime value) {
                          setState(() {
                            _selectedDate = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Edad: ${_calculateAge(_selectedDate)} años",
                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
          _agregarFechaNacimiento(context);
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Future<void> _agregarFechaNacimiento(BuildContext context) async {
    try {
      int edad = _calculateAge(_selectedDate);

      Map<String, dynamic> userData = {
        'primeros_pasos': 3,
        'edad': edad,
        'fechaNacimiento': _selectedDate,
      };

      await  UserService.updateUser(userData, context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PesoPage()));
      await PhysicalDataService.createPhysicalData(context);
    } catch (error) {
      print('Error: $error');
    }
  }
}
