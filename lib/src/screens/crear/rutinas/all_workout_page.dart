import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/screens/crear/rutinas/view_workout_page.dart';
import 'package:gym_check/src/screens/crear/series/view_serie_page.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllWorkoutPage extends StatefulWidget {
  @override
  _AllWorkoutPageState createState() => _AllWorkoutPageState();
}

class _AllWorkoutPageState extends State<AllWorkoutPage> {
  late Stream<List<Workout>> _workoutStream;
  TextEditingController _searchController = TextEditingController();
  int _selectedMenuOption = 0;

  List<String> options = [
    'Todo',
    'Creados por mí',
    'Favoritos',
  ]; // Lista de opciones
  List<Color> highlightColors = [
    const Color.fromARGB(255, 94, 24, 246),
    const Color.fromARGB(255, 94, 24, 246),
    const Color.fromARGB(255, 94, 24, 246),
  ];

  @override
  void initState() {
    super.initState();
    _workoutStream = obtenerTodasRutinasStream();
    _loadSelectedMenuOption();
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        //_selectedMenuOption = prefs.getInt('diaSeleccionado') ?? 0;
      });
      //_loadRoutines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Buscar rutina',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _workoutStream = obtenerRutinasFiltradasStream(query);
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width - 20,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        setState(() {
                          _selectedMenuOption = index;
                        });
                      },
                      selectedMenuOptionGlobal: _selectedMenuOption,
                    ),
                    // Puedes agregar más elementos MenuButtonOption según sea necesario
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Workout>>(
              stream: _workoutStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final workouts = snapshot.data!;
                  return Column(
                    children: workouts.map((workout) {
                      return WorkoutContainer(workout: workout);
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<Workout>> obtenerTodasRutinasStream() {
    try {
      final workoutStream = RutinaService.obtenerTodasRutinasStream(context);
      return workoutStream;
    } catch (error) {
      print('Error al obtener todas las rutinas: $error');
      throw error;
    }
  }

  Stream<List<Workout>> obtenerRutinasFiltradasStream(String query) {
    try {
      final workoutStream = RutinaService.obtenerRutinasFiltradasStream(context, query);
      return workoutStream;
    } catch (error) {
      print('Error al obtener las rutinas filtradas: $error');
      throw error;
    }
  }
}

class WorkoutContainer extends StatelessWidget {
  final Workout workout;

  const WorkoutContainer({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Agregar lógica aquí
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        workout.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Lógica para agregar a favoritos
                        },
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${workout.primaryFocus}, ${workout.secondaryFocus}, ${workout.thirdFocus}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: const Color.fromARGB(255, 18, 18, 18),
                            scrollControlDisabledMaxHeightRatio: 0.9,
                            enableDrag: false,
                            showDragHandle: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.96,
                                child: ViewWorkoutPage(id: workout.id ?? ""),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.info, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
