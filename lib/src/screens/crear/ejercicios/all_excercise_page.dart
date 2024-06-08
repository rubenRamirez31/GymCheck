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
  String? _selectedEnfoque;

  List<String> options = ['Todo', 'Por enfoque', 'Favoritos'];
  List<Color> highlightColors = [
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _exerciseStream = _getExerciseStreamForOption(_selectedMenuOption);
    // _loadSelectedMenuOption();
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedMenuOption = prefs.getInt('selectedMenuOption') ?? 0;
      });
    }
  }

  Stream<List<Exercise>> _getExerciseStreamForOption(int option) {
    switch (option) {
      case 0:
        return obtenerEjerciciosFiltradosStream(_searchController.text,
            enfoque: _selectedEnfoque);
      case 1:
        return obtenerEjerciciosFiltradosStream(_searchController.text,
            enfoque: _selectedEnfoque);
      case 2:
        return obtenerEjerciciosFavoritosStream(_searchController.text,
            enfoque: _selectedEnfoque);
      default:
        return obtenerTodosEjerciciosStream();
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
              // padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          _exerciseStream =
                              _getExerciseStreamForOption(_selectedMenuOption);
                        });
                        // await prefs.setInt('selectedMenuOption', index);
                        print(_selectedMenuOption);
                      },
                      selectedMenuOptionGlobal: _selectedMenuOption,
                    ),
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
                labelText: 'Buscar ejercicio',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _exerciseStream =
                      _getExerciseStreamForOption(_selectedMenuOption);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            if (_selectedMenuOption == 1 ||
                _selectedMenuOption ==
                    2) // Mostrar el menú desplegable solo si "Por enfoque" está seleccionado
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
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _selectedEnfoque,
                            hint: const Text(
                              'Seleccionar enfoque',
                              style: TextStyle(color: Colors.white),
                            ),
                            dropdownColor:
                                const Color.fromARGB(255, 55, 55, 55),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedEnfoque = newValue;
                                _exerciseStream = _getExerciseStreamForOption(
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
                              _exerciseStream = _getExerciseStreamForOption(
                                  _selectedMenuOption);
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
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

            SizedBox(height: 30,)
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

  Stream<List<Exercise>> obtenerEjerciciosFiltradosStream(String query,
      {String? enfoque}) {
    try {
      final exercisesStream = ExerciseService.obtenerEjerciciosFiltradosStream(
          context, query,
          enfoque: enfoque);
      return exercisesStream;
    } catch (error) {
      print('Error al obtener los ejercicios filtrados: $error');
      throw error;
    }
  }

  Stream<List<Exercise>> obtenerEjerciciosFavoritosStream(String query,
      {String? enfoque}) {
    try {
      final exercisesStream =
          ExerciseService.obtenerEjerciciosFiltradosFavoritosStream(
              context, query,
              enfoque: enfoque);
      return exercisesStream;
    } catch (error) {
      print('Error al obtener los ejercicios favoritos: $error');
      throw error;
    }
  }
}

class ExerciseContainer extends StatefulWidget {
  final Exercise exercise;
  final bool agregar;

  const ExerciseContainer(
      {Key? key, required this.exercise, required this.agregar})
      : super(key: key);

  @override
  _ExerciseContainerState createState() => _ExerciseContainerState();
}

class _ExerciseContainerState extends State<ExerciseContainer> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final bool isFavorite =
          await ExerciseService.esFavorito(context, widget.exercise.id ?? "");
      setState(() {
        _isFavorite = isFavorite;
      });
    } catch (error) {
      print('Error al cargar estado de favorito: $error');
    }
  }

  Future<void> _toggleFavoriteStatus() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    try {
      if (_isFavorite) {
        await ExerciseService.agregarAFavoritos(context, widget.exercise);
      } else {
        await ExerciseService.quitarDeFavoritos(
            context, widget.exercise.id ?? "");
      }
    } catch (error) {
      print('Error al agregar/eliminar ejercicio de favoritos: $error');
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String primary = widget.exercise.primaryFocus;
    String secondary = widget.exercise.secondaryFocus;

    return GestureDetector(
      onTap: () {
        if (widget.agregar == true) {
          Navigator.of(context).pop(widget.exercise);
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
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                  width: 100,
                  height: 100,
                  child: widget.exercise.representativeImageLink.isNotEmpty
                      ? Image.network(
                          widget.exercise.representativeImageLink,
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
                                  widget.exercise.name,
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
                                  "$primary y $secondary",
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
                              onPressed: _toggleFavoriteStatus,
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
                                    child: ViewExercisePage(
                                      id: widget.exercise.id ?? "",
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
                                  widget.exercise.name,
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
                                  "$primary y $secondary",
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
                                      child: ViewExercisePage(
                                          id: widget.exercise.id ?? "",
                                          buttons: true),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.more_horiz),
                            ),
                            IconButton(
                              onPressed: _toggleFavoriteStatus,
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
