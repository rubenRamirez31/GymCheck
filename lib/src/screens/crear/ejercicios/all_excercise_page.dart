import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/screens/crear/ejercicios/view_excercise_page.dart';
import 'package:gym_check/src/services/excercise_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllExercisePage extends StatefulWidget {
  final bool agregar;

  const AllExercisePage({Key? key, required this.agregar}) : super(key: key);

  @override
  _AllExercisePageState createState() => _AllExercisePageState();
}

class _AllExercisePageState extends State<AllExercisePage> {
  late Stream<List<Exercise>> _exerciseStream;
  TextEditingController _searchController = TextEditingController();
  int _selectedMenuOption = 0;

  List<String> options = [
    'Todo',
    'Por enfoque',
    'Favoritos',
  ]; // Lista de opciones
  List<Color> highlightColors = [
    Colors.green,
    Colors.green,
    Colors.green,
  ];
  @override
  void initState() {
    super.initState();
    _exerciseStream = obtenerTodosEjerciciosStream();
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
                labelText: 'Buscar ejercicio',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _exerciseStream = obtenerEjerciciosFiltradosStream(query);
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
                        //highlightColor: Colors.green,
                        onItemSelected: (index) async {
                          // SharedPreferences prefs =await SharedPreferences.getInstance();
                          setState(() {
                            _selectedMenuOption = index;
                            // globalVariable.selectedMenuOptionDias =
                            _selectedMenuOption;
                          });
                          // await prefs.setInt('diaSeleccionado', index);
                          // print(index);
                          // _loadRoutines();
                        },
                        //selectedMenuOptionGlobal:globalVariable.selectedMenuOptionDias),
                        selectedMenuOptionGlobal: _selectedMenuOption),
                    // Aquí puedes agregar más elementos MenuButtonOption según sea necesario
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Exercise>>(
              stream: _exerciseStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final exercises = snapshot.data!;
                  return Column(
                    children: exercises.map((exercise) {
                      return ExerciseContainer(
                        exercise: exercise,
                        agregar: widget.agregar,
                      );
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

  Stream<List<Exercise>> obtenerTodosEjerciciosStream() {
    try {
      final exercisesStream =
          ExerciseService.obtenerTodosEjerciciosStream(context);
      return exercisesStream;
    } catch (error) {
      print('Error al obtener todos los ejercicios: $error');
      throw error;
    }
  }

  Stream<List<Exercise>> obtenerEjerciciosFiltradosStream(String query) {
    try {
      final exercisesStream =
          ExerciseService.obtenerEjerciciosFiltradosStream(context, query);
      return exercisesStream;
    } catch (error) {
      print('Error al obtener los ejercicios filtrados: $error');
      throw error;
    }
  }
}

class ExerciseContainer extends StatelessWidget {
  final Exercise exercise;
  final bool agregar;

  const ExerciseContainer(
      {Key? key, required this.exercise, required this.agregar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String primary = exercise.primaryFocus;
    String secondary = exercise.secondaryFocus;

    return GestureDetector(
      onTap: () {
        if (agregar == true) {
          Navigator.of(context).pop(exercise);
        } else {
          ///accion
        }
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
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                  width: 100,
                  height: 100,
                  child: exercise.representativeImageLink.isNotEmpty
                      ? Image.network(
                          exercise.representativeImageLink,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('No hay imagen');
                          },
                          frameBuilder: (BuildContext context, Widget child,
                              int? frame, bool wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              child: child,
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOut,
                            );
                          },
                          headers: {
                            'Accept': '*/*',
                            'User-Agent': 'your_user_agent',
                          },
                        )
                      : const Center(
                          child: Text('Imagen no encontrada'),
                        ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exercise.name,
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
                          icon: const Icon(Icons.favorite_border,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  if (agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$primary y $secondary",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor:
                                  const Color.fromARGB(255, 18, 18, 18),
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
                                  child: ViewExercisePage(
                                      id: exercise.id ?? "", buttons: false),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.info, color: Colors.grey),
                        ),
                      ],
                    ),
                  if (agregar == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor:
                                  const Color.fromARGB(255, 18, 18, 18),
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
                                  child: ViewExercisePage(
                                      id: exercise.id ?? "", buttons: true),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                  if (agregar == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$primary y $secondary",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Lógica para agregar a favoritos
                          },
                          icon: const Icon(Icons.favorite_border,
                              color: Colors.red),
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
