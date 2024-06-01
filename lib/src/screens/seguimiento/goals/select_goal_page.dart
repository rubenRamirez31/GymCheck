import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_tdee_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_drop_dowm_wiget.dart';

class SelectGoalPage extends StatefulWidget {
  const SelectGoalPage({Key? key}) : super(key: key);

  @override
  _SelectGoalPageState createState() => _SelectGoalPageState();
}

class _SelectGoalPageState extends State<SelectGoalPage> {
  String? _selectedGoal = 'Pérdida de peso'; // Meta predeterminada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Selecciona tu meta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color.fromARGB(255, 18, 18, 18),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDropdown(
                hint: 'Seleccionar',
                value: _selectedGoal,
                items: const <String>[
                  'Pérdida de peso',
                  'Aumento de masa muscular',
                  'Definición muscular',
                  'Mantener peso',
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedGoal = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildGoalInfo(_selectedGoal ?? ""),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedGoal != null && _selectedGoal!.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectTdeePage(tipoMeta: _selectedGoal ?? ""),
                  ),
                );
              },
              backgroundColor:
                  const Color(0xff0C1C2E), // Color de fondo del botón flotante
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white), // Color del icono del botón flotante
            )
          : null,
    );
  }

  Widget _buildGoalInfo(String selectedGoal) {
    String description = '';
    switch (selectedGoal) {
      case 'Pérdida de peso':
        description =
            'Esta meta se centra en reducir el peso corporal, generalmente con el objetivo de mejorar la salud, aumentar la confianza en uno mismo o mejorar la apariencia física. Para lograr la pérdida de peso de manera saludable, se suele hacer hincapié en la creación de un déficit calórico a través de una combinación de dieta y ejercicio.';
        break;
      case 'Aumento de masa muscular':
        description =
            'Aquí, el objetivo es ganar masa muscular magra para aumentar la fuerza, mejorar la composición corporal y lograr un aspecto más definido. Para lograr este objetivo, se suele enfatizar el consumo adecuado de proteínas, junto con un entrenamiento de fuerza progresivo y suficiente descanso.';
        break;
      case 'Definición muscular':
        description =
            'La definición muscular implica reducir el porcentaje de grasa corporal mientras se conserva la masa muscular magra. Esto ayuda a resaltar los músculos y lograr un aspecto más tonificado y atlético. Para alcanzar esta meta, se requiere una combinación de ejercicio cardiovascular, entrenamiento de fuerza y una dieta equilibrada que favorezca la pérdida de grasa.';
        break;
      case 'Mantener peso':
        description =
            'Esta meta se trata de mantener un peso corporal saludable y estable una vez que se ha alcanzado. Implica equilibrar la ingesta de alimentos y el gasto energético para evitar ganar o perder peso de manera significativa. Esto generalmente se logra mediante la adopción de hábitos alimenticios saludables y la incorporación de actividad física regular en la rutina diaria.';
        break;
      case '':
        description = 'Selecciona tu meta principal';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 83, 83, 83),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        description,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
