import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/rutinas/create_workout_page.dart';

import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
import 'package:gym_check/src/screens/crear/widgets/create_widgets.dart';
import 'package:gym_check/src/services/serie_service.dart';
import 'package:provider/provider.dart';

class ViewWorkoutSeriesPage extends StatefulWidget {
  final String id;
  final bool buttons; //mostrar botones

  const ViewWorkoutSeriesPage(
      {Key? key, required this.id, required this.buttons})
      : super(key: key);

  @override
  _ViewWorkoutSeriesPageState createState() => _ViewWorkoutSeriesPageState();
}

class _ViewWorkoutSeriesPageState extends State<ViewWorkoutSeriesPage> {
  WorkoutSeries? _workoutSeries;
  //Map<String, dynamic> item= [''];

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
    Globales globales = Provider.of<Globales>(context, listen: false);
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
                        CreateWidgets.buildLabelDetailsRowOnly(
                          _workoutSeries!.name, MainAxisAlignment.center
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                          "Creado por: ",
                          _workoutSeries!.nick,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.buttons == true)
                              RawMaterialButton(
                                onPressed: () {
                                  // Lógica para agregar a favoritos
                                  print('Agregar a favoritos');
                                },
                                fillColor: Colors.grey[200],
                                shape: const CircleBorder(),
                                child: const Icon(Icons.favorite_border,
                                    color: Colors.black),
                              ),
                            if (widget.buttons == true)
                              RawMaterialButton(
                                
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CrearWorkoutPage(
                                            serieID: widget.id)),
                                  );
                                },
                                
                                fillColor: Colors.grey[200],
                                shape: const CircleBorder(),
                                child: const Icon(Icons.sports_gymnastics,
                                    color: Colors.black),
                              ),
                            if (widget.buttons == true)
                            if (_workoutSeries?.nick == globales.nick)
                              RawMaterialButton(
                                onPressed: () {
                                  // Lógica para editar
                                  print('Editar');
                                },
                                fillColor: Colors.grey[200],
                                shape: const CircleBorder(),
                                child:
                                    const Icon(Icons.edit, color: Colors.black),
                              ),
                            if (widget.buttons == true)
                            if (_workoutSeries?.isPublic == true)
                              RawMaterialButton(
                                onPressed: () {
                                  // Lógica para editar
                                  print('Editar');
                                },
                                fillColor: Colors.grey[200],
                                shape: const CircleBorder(),
                                child:
                                    const Icon(Icons.share, color: Colors.black),
                              ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                            "Enfoque principal:", _workoutSeries!.primaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                            "Enfoque secundario:",
                            _workoutSeries!.secondaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRowOnly("Descripción:", MainAxisAlignment.center),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelGeneral(
                            _workoutSeries!.description, 14),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            "Contenido de la serie:", MainAxisAlignment.center),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildExercisesList(),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                            "Sets:", _workoutSeries!.sets.toString()),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                            "Descansos entre sets(segundos):",
                            _workoutSeries!.restBetweenSets.toString()),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                // if (widget.buttons == true)
                //   Positioned(
                //     top: 80,
                //     right: 20,
                //     child: FloatingActionButton(
                //       backgroundColor: const Color(0xff0C1C2E),
                //       tooltip: "Agregar a rutina",
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) =>
                //                   CrearWorkoutPage(serieID: widget.id)),
                //         );
                //       },
                //       child: const Icon(
                //         Icons.sports_gymnastics,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // if (widget.buttons == true)
                //   Positioned(
                //     top: 20,
                //     right: 20,
                //     child: FloatingActionButton(
                //       tooltip: "Agregr a favoritos",
                //       backgroundColor: const Color(0xff0C1C2E),
                //       onPressed: () {
                //         // Lógica para agregar a favoritos
                //         print('Agregar a favoritos');
                //       },
                //       child: const Icon(
                //         Icons.favorite_border,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // if (_workoutSeries?.nick == globales.nick)
                //   Positioned(
                //     top: 140,
                //     right: 20,
                //     child: FloatingActionButton(
                //       tooltip: "Modificar",
                //       backgroundColor: const Color(0xff0C1C2E),
                //       onPressed: () {
                //         // Lógica para agregar a favoritos
                //         print('Agregar a favoritos');
                //       },
                //       child: const Icon(
                //         Icons.edit,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
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

  Widget _buildExercisesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _workoutSeries!.exercises.map((exerciseMap) {
        if (exerciseMap.containsKey('exercise')) {
          final exercise = exerciseMap['exercise'] as Map<String, dynamic>;
          return ExerciseContainer(
            name: exercise['nombre'],
            repetitions: exercise['repetitions'],
            item: exercise,
          );
        } else if (exerciseMap.containsKey('descanso')) {
          final rest = exerciseMap['descanso'] as int;
          return RestContainer(duration: rest);
        } else {
          return const SizedBox(); // Manejar otros casos si es necesario
        }
      }).toList(),
    );
  }
}

class ExerciseContainer extends StatelessWidget {
  final String name;
  final int repetitions;
  final Map<String, dynamic> item;

  const ExerciseContainer({
    Key? key,
    required this.name,
    required this.repetitions,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Lógica que deseas ejecutar cuando se toque el contenedor
        _verinformacionItem(item, context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Repeticiones: $repetitions',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _verinformacionItem(
      Map<String, dynamic> item, BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      enableDrag: false,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        Map<String, dynamic> ejercicio = item;
        String nombreEjercicio = ejercicio['nombre'];
        int repeticiones = ejercicio['repetitions'];
        String equipamiento = ejercicio['equipmentSelect'];

        return FractionallySizedBox(
          widthFactor: 1.0, // Ajustar al ancho de la pantalla
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del Ejercicio',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text('Nombre: $nombreEjercicio',
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  Text('Repeticiones: $repeticiones',
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  Text('Equipamiento: $equipamiento',
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Descanso: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '$duration segundos',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
