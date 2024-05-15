import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/screens/crear/rutinas/create_workout_page.dart';

import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
import 'package:gym_check/src/services/serie_service.dart';


class ViewWorkoutSeriesPage extends StatefulWidget {
  final String id;
  final bool buttons; //mostrar botones

  const ViewWorkoutSeriesPage({Key? key, required this.id, required this.buttons})
      : super(key: key);

  @override
  _ViewWorkoutSeriesPageState createState() => _ViewWorkoutSeriesPageState();
}

class _ViewWorkoutSeriesPageState extends State<ViewWorkoutSeriesPage> {
  WorkoutSeries? _workoutSeries;

  @override
  void initState() {
    super.initState();
    _loadWorkoutSeries();
  }

  Future<void> _loadWorkoutSeries() async {
    try {
      final workoutSeries =
          await SerieService.obtenerSeriePorId(context, widget.id);
      setState(() {
        _workoutSeries = workoutSeries;
      });
    } catch (error) {
      print('Error loading workout series: $error');
      // Manejo de error si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      body: _workoutSeries != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [

                        _buildImage(),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRowOnly(
                          _workoutSeries!.name,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRow(
                            "Descripción:", _workoutSeries!.description),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildExercisesList(),
                      ],
                    ),
                  ),
                ),
                if (widget.buttons == true)
                  Positioned(
                    top: 80,
                    right: 20,
                    child: FloatingActionButton(
                       backgroundColor: const Color(0xff0C1C2E),
                      tooltip: "Agregar a rutina",
                      onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute( builder: (context) => CrearWorkoutPage(serieID: widget.id)),
                         );
                      },
                      child: Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (widget.buttons == true)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                       backgroundColor: const Color(0xff0C1C2E),
                      onPressed: () {
                        // Lógica para agregar a favoritos
                        print('Agregar a favoritos');
                      },
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  
  Widget _buildImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      width: 200,
      height: 200,
     
    );
  }
  Widget _buildLabelDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelDetailsRowOnly(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercisesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _workoutSeries!.exercises.map((exerciseMap) {
        if (exerciseMap.containsKey('exercise')) {
          final exercise = exerciseMap['exercise'] as Map<String, dynamic>;
          return ExerciseContainer(
            name: exercise['nombre'],
            repetitions: exercise['repetitions'],
          );
        } else if (exerciseMap.containsKey('descanso')) {
          final rest = exerciseMap['descanso'] as int;
          return RestContainer(duration: rest);
        } else {
          return SizedBox(); // Manejar otros casos si es necesario
        }
      }).toList(),
    );
  }
}

class ExerciseContainer extends StatelessWidget {
  final String name;
  final int repetitions;

  const ExerciseContainer({
    Key? key,
    required this.name,
    required this.repetitions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Repeticiones: $repetitions',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class RestContainer extends StatelessWidget {
  final int duration;

  const RestContainer({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Descanso: $duration segundos',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
