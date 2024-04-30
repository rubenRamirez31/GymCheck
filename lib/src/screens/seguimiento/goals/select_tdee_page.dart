import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/goals/selec_data_corporal.dart';

class SelectTdeePage extends StatefulWidget {
  final String tipoMeta;

  const SelectTdeePage({Key? key, required this.tipoMeta}) : super(key: key);

  @override
  _SelectTdeePageState createState() => _SelectTdeePageState();
}

class _SelectTdeePageState extends State<SelectTdeePage> {
  int gymVisitsPerWeek = 0;
  late String recommendation;

  void calculateRecommendation() {
    switch (widget.tipoMeta) {
      case 'Pérdida de peso':
        recommendation = 'Te recomendamos ir al gimnasio al menos 3 veces por semana.';
        break;
      case 'Aumento de masa muscular':
        recommendation = 'Te recomendamos ir al gimnasio al menos 4 veces por semana.';
        break;
      case 'Definición muscular':
        recommendation = 'Te recomendamos ir al gimnasio al menos 5 veces por semana.';
        break;
      case 'Mantener peso':
        recommendation = 'Te recomendamos ir al gimnasio al menos 2 veces por semana.';
        break;
      default:
        recommendation = '';
    }
  }

  double calculateTdee(int gymVisitsPerWeek) {
    if (gymVisitsPerWeek <= 1) {
      return 1.55; // Sedentario
    } else if (gymVisitsPerWeek <= 3) {
      return 1.85; // Moderadamente activo
    } else if (gymVisitsPerWeek <= 5) {
      return 2.2; // Muy activo
    } else {
      return 2.4; // Extremadamente activo
    }
  }

  String getTdeeDescription(double tdee) {
    switch (tdee) {
      case 1.55:
        return 'Empleado de oficina haciendo poco o nada de ejercicio';
      case 1.85:
        return 'Persona con un trabajo sedentario que hace cardio / entrenar con pesas 1 hora al día';
      case 2.2:
        return 'Persona con un trabajo que implica actividad moderada durante aproximadamente 8 horas diarias';
      case 2.4:
        return 'Ciclista de competición (3-4 horas diarias, o deporte equivalente)';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    calculateRecommendation();
  }

  @override
  Widget build(BuildContext context) {
    final tdee = calculateTdee(gymVisitsPerWeek);
    final description = getTdeeDescription(tdee);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Nivel de actividad física',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color.fromARGB(255, 18, 18, 18),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingresa la cantidad de veces que vas al gimnasio a la semana:',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 83, 83, 83),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (gymVisitsPerWeek > 0) {
                            gymVisitsPerWeek--;
                          }
                        });
                      },
                      icon: const Icon(Icons.remove),
                      color: Colors.white,
                    ),
                    Text(
                      '$gymVisitsPerWeek veces por semana',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gymVisitsPerWeek++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // const Text(
              //   'Recomendación:',
              //   style: TextStyle(fontSize: 18, color: Colors.white),
              // ),
              // Text(
              //   recommendation,
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(color: Colors.white),
              // ),
            
              const Text(
                'Tu nivel de actividad física es:',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DatosCorporalesPage(tdee: tdee, tipoMeta: widget.tipoMeta)),
          );
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
