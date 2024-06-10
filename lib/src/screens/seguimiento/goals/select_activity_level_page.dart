import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/goals/selec_data_corporal.dart';

class SelectActivityLevelPage extends StatefulWidget {
  final String tipoMeta;

  const SelectActivityLevelPage({Key? key, required this.tipoMeta}) : super(key: key);

  @override
  _SelectActivityLevelPageState createState() => _SelectActivityLevelPageState();
}

class _SelectActivityLevelPageState extends State<SelectActivityLevelPage> {


  String selectedActivityLevel = 'Sedentario';
  String activityDescription = 'Empleado de oficina haciendo poco o nada de ejercicio';

  void updateActivityDescription(String level) {
    switch (level) {
      case 'Sedentario':
        activityDescription = 'Empleado de oficina haciendo poco o nada de ejercicio';
        break;
      case 'Ligero':
        activityDescription = 'Persona con un trabajo sedentario que hace cardio / entrenar con pesas 1 hora al día';
        break;
      case 'Moderado':
        activityDescription = 'Persona con un trabajo que implica actividad moderada durante aproximadamente 8 horas diarias';
        break;
      case 'Activo':
        activityDescription = 'Ciclista de competición (3-4 horas diarias, o deporte equivalente)';
        break;
      case 'Muy Activo':
        activityDescription = 'Atleta de élite o persona con un trabajo físicamente muy exigente';
        break;
      default:
        activityDescription = '';
    }
  }

  @override
  void initState() {
    super.initState();
    updateActivityDescription(selectedActivityLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Seleccionar nivel de actividad física',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color.fromARGB(255, 18, 18, 18),
        child: Column(
          children: [
            const Text(
              'Selecciona tu nivel de actividad física:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedActivityLevel,
              dropdownColor: const Color.fromARGB(255, 83, 83, 83),
              icon: const Icon(Icons.arrow_downward, color: Colors.white),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              underline: Container(
                height: 2,
                color: const Color(0xff0C1C2E),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivityLevel = newValue!;
                  updateActivityDescription(selectedActivityLevel);
                });
              },
              items: <String>['Sedentario', 'Ligero', 'Moderado', 'Activo', 'Muy Activo']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              activityDescription,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatosCorporalesPage(
                tdee: selectedActivityLevel,
                tipoMeta: widget.tipoMeta,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
