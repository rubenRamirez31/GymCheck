import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/screens/crear/rutinas/view_workout_page.dart';
import 'package:gym_check/src/screens/crear/series/view_serie_page.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllWorkoutPage extends StatefulWidget {
  final bool agregar;

  const AllWorkoutPage({Key? key, required this.agregar}) : super(key: key);

  @override
  _AllWorkoutPageState createState() => _AllWorkoutPageState();
}

class _AllWorkoutPageState extends State<AllWorkoutPage> {
  late Stream<List<Workout>> _workoutStream;
  TextEditingController _searchController = TextEditingController();
  int _selectedMenuOption = 0;
  String? _selectedEnfoque;

  List<String> options = ['Creados por mí', 'Todo', 'Favoritos'];
  List<Color> highlightColors = [Colors.white, Colors.white, Colors.white];

  @override
  void initState() {
    super.initState();
    _workoutStream = _getWorkoutStreamForOption(_selectedMenuOption);
   // _loadSelectedMenuOption();
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
            Container(
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width - 20,
              //padding: const EdgeInsets.symmetric(horizontal: 30),
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
                          _workoutStream =
                              _getWorkoutStreamForOption(_selectedMenuOption);
                        });
                      },
                      selectedMenuOptionGlobal: _selectedMenuOption,
                    ),
                    // Puedes agregar más elementos MenuButtonOption según sea necesario
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                  _workoutStream = obtenerRutinasFiltradasStream(query,
                      cradospormi: false, todo: false);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300, // Ancho deseado
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _selectedEnfoque,
                          hint: const Text(
                            'Seleccionar enfoque',
                            style: TextStyle(color: Colors.white),
                          ),
                          dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedEnfoque = newValue;
                              _workoutStream = _getWorkoutStreamForOption(
                                  _selectedMenuOption);
                            });
                          },
                          items: <String>[
  'Pecho',
  'Espalda',
  'Hombros',
  'Bíceps',
  'Tríceps',
  'Antebrazo',
  'Cuádriceps',
  'Femoral',
  'Abductores',
  'Glúteos',
  'Gemelos',
  'Abdomen',
  'Core',
  'Trapecio',
].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedEnfoque = null;
                            _workoutStream =
                                _getWorkoutStreamForOption(_selectedMenuOption);
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                      return WorkoutContainer(
                        workout: workout,
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

  Stream<List<Workout>> _getWorkoutStreamForOption(int option) {
    switch (option) {
      case 0:
        return obtenerRutinasFiltradasStream(_searchController.text,
            cradospormi: true, todo: false);
      case 1:
        return obtenerRutinasFiltradasStream(_searchController.text,
            cradospormi: false, todo: true);
      case 2:
        return obtenerRutinasFiltradasStream(_searchController.text,
            cradospormi: false, todo: false);
      default:
        return obtenerTodasRutinasStream();
    }
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

  Stream<List<Workout>> obtenerRutinasFiltradasStream(String query,
      {required bool cradospormi, required bool todo}) {
    try {
      final workoutStream = RutinaService.obtenerRutinasFiltradasStream(
          context, query, cradospormi, todo,
          enfoque: _selectedEnfoque);
      return workoutStream;
    } catch (error) {
      print('Error al obtener las rutinas filtradas: $error');
      throw error;
    }
  }
}

class WorkoutContainer extends StatefulWidget {
  final Workout workout;
  final bool agregar;

  const WorkoutContainer(
      {Key? key, required this.workout, required this.agregar})
      : super(key: key);

  @override
  _WorkoutContainerState createState() => _WorkoutContainerState();
}

class _WorkoutContainerState extends State<WorkoutContainer> {
  bool _isFavorite =
      false; // Estado para controlar si el entrenamiento está marcado como favorito

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.agregar == true) {
          Navigator.of(context).pop(widget.workout);
        } else {
          /// acción
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
              children: [
               widget.workout.urlImagen.isNotEmpty
  ? Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.workout.urlImagen,
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
          fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
        ),
      ),
    )
  : Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
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
                  if (widget.agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Align texts left
                              children: [
                                Text(
                                  widget.workout.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Truncate long text with ellipsis
                                ),
                                Text(
                                  "${widget.workout.primaryFocus}, ${widget.workout.secondaryFocus}, ${widget.workout.thirdFocus}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Creada por:${widget.workout.nick}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  // Cambiar el estado de favorito al contrario
                                  _isFavorite = !_isFavorite;
                                  if (_isFavorite) {
                                    // Lógica para agregar a favoritos
                                  } else {
                                    // Lógica para quitar de favoritos
                                  }
                                });
                              },
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.grey,
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
                                      top: Radius.circular(15.0),
                                    ),
                                  ),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => FractionallySizedBox(
                                    heightFactor: 0.96,
                                    child: ViewWorkoutPage(
                                      id: widget.workout.id ?? "",
                                      buttons: false,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (widget.agregar == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Align texts left
                              children: [
                                Text(
                                  widget.workout.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Truncate long text with ellipsis
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${widget.workout.primaryFocus}, ${widget.workout.secondaryFocus}, ${widget.workout.thirdFocus}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Creado por :${widget.workout.nick}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                      child: ViewWorkoutPage(
                                        id: widget.workout.id ?? "",
                                        buttons: true
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.more_horiz),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  // Cambiar el estado de favorito al contrario
                                  _isFavorite = !_isFavorite;
                                  if (_isFavorite) {
                                    // Lógica para agregar a favoritos
                                  } else {
                                    // Lógica para quitar de favoritos
                                  }
                                });
                              },
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.grey,
                              ),
                            ),
                          ],
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
