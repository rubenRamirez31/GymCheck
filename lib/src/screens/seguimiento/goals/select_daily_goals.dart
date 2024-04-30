import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/widgets/date_time_selector.dart';

import 'package:gym_check/src/screens/seguimiento/goals/select_duaration_page.dart';

class SelectDailyGoals extends StatefulWidget {
  final Map<String, dynamic> macros;
  final String tipoMeta;

  const SelectDailyGoals(
      {Key? key, required this.macros, required this.tipoMeta})
      : super(key: key);

  @override
  _SelectDailyGoals createState() => _SelectDailyGoals();
}

class _SelectDailyGoals extends State<SelectDailyGoals> {
  late Map<String, Map<String, dynamic>> selectedGoals;

  @override
  void initState() {
    super.initState();
    selectedGoals = {
      'Consumo de proteinas': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': widget.macros['proteinas'] ?? 0,
      },
      'Consumo de carbohidratos': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': widget.macros['carbohidratos'] ?? 0,
      },
      'Consumo de grasas': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': widget.macros['grasas'] ?? 0,
      },
      'Consumo diario de agua': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 2000.0,
      },
      'Cumplimiento de rutina diaria': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 0.0,
      },
      'Estiramiento matutino': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 0.0,
      },
      'Estiramiento nocturno': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 0.0,
      },
      'Estiramiento para flexibilidad': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor':0.0,
      },
      'Descanso adecuado': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 8.0,
      },
      'Reducción del estrés': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 0.0,
      },
      'Control del estado de ánimo': {
        'selected': false,
        'reminderTime': DateTime.now(),
        'valor': 1,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Metas diarias',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Selecciona tus metas diarias",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: selectedGoals.entries.map((entry) {
                  return buildGoalContainer(entry.key, entry.value);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectDuration(
                selectedGoals: selectedGoals,
                macros: widget.macros,
                goalType: widget.tipoMeta,
              ),
            ),
          ); // Directamente proporcionamos la instancia de la clase SecondPage
          print(selectedGoals); // Aquí se imprimirán las metas seleccionadas
        },
        child: const Icon(Icons.arrow_forward, color: Colors.white),
        backgroundColor: const Color(0xff0C1C2E),
        // child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Widget buildGoalContainer(String goal, Map<String, dynamic> goalData) {
    return GestureDetector(
      onTap: () {
        setState(() {
          goalData['selected'] = !goalData['selected'];
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: goalData['selected']
              ? const Color.fromARGB(255, 163, 163, 163)
              : const Color.fromARGB(255, 83, 83, 83),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal,
                  style: TextStyle(
                    fontSize: goalData['selected'] ? 20 : 16,
                    color: goalData['selected'] ? Colors.black : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Mostrar información sobre la meta
                    // Aquí puedes implementar la lógica para mostrar una descripción de la meta
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(goal),
                        content: const Text(
                            'Descripción de la meta...'), // Aquí puedes agregar la descripción correspondiente a la meta
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info),
                  color: goalData['selected'] ? Colors.black : Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Hora de recordatorio:',
                style: TextStyle(
                    color: goalData['selected'] ? Colors.black : Colors.white)),
            const SizedBox(height: 8),
            DateTimeSelectorFormField(
              decoration: const InputDecoration(),
              initialDateTime: goalData['reminderTime'],
              minimumDateTime: DateTime(2000),
              onSelect: (date) {
                setState(() {
                  goalData['reminderTime'] = date ?? DateTime.now();
                });
              },
              type: DateTimeSelectionType.time,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: goalData['selected'],
                  onChanged: (value) {
                    setState(() {
                      goalData['selected'] = value ?? false;
                    });
                  },
                  checkColor: Colors.black,
                  fillColor: MaterialStateProperty.resolveWith((states) =>
                      goalData['selected'] ? Colors.white : Colors.transparent),
                ),
                Text('Seleccionar esta meta',
                    style: TextStyle(
                        color: goalData['selected']
                            ? Colors.black
                            : Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
