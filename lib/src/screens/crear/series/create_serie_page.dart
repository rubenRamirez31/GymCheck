import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/ejercicios/all_excercise_page.dart';
import 'package:gym_check/src/services/excercise_service.dart';
import 'package:gym_check/src/services/serie_service.dart';
import 'package:provider/provider.dart';

class CrearSeriePage extends StatefulWidget {
  final String? ejercicioId;

  const CrearSeriePage({Key? key, this.ejercicioId}) : super(key: key);

  @override
  _CrearSeriePageState createState() => _CrearSeriePageState();
}

class _CrearSeriePageState extends State<CrearSeriePage> {
  @override
  void initState() {
    super.initState();
    _loadExerciseSelect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Crear serie',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        iconTheme: IconThemeData(
          color:
              Colors.white, // Cambia el color del icono de retroceso a blanco
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              //agregarEjercicio();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _nombreController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la serie'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre para la serie';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    const Text('Sets: '),
                    DropdownButton<int>(
                      value: _sets,
                      onChanged: (value) {
                        setState(() {
                          _sets = value!;
                        });
                      },
                      items: List.generate(5, (index) => index + 1)
                          .map((value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              ))
                          .toList(),
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Descanso entre sets (segundos)'),
                  onChanged: (value) {
                    setState(() {
                      _descansoEntreSets = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                _ejercicios.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300, // Altura máxima de 300 píxeles
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _ejercicios.map((item) {
                                if (item.containsKey('exercise')) {
                                  // Ejercicio
                                  Map<String, dynamic> ejercicio =
                                      item['exercise'];
                                  String nombreEjercicio = ejercicio['nombre'];
                                  int repeticiones = ejercicio['repetitions'];
                                  String equipamiento =
                                      ejercicio['equipmentSelect'];

                                  return GestureDetector(
                                    onTap: () {
                                      _verinformacionItem(item);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '$nombreEjercicio: $repeticiones reps',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  _editarAtributos(item);
                                                },
                                                icon: const Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  _eliminar(item);
                                                },
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (item.containsKey('descanso')) {
                                  // Descanso
                                  int segundos = item['descanso'];

                                  return GestureDetector(
                                    onTap: () {
                                      _verinformacionItem(item);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Descanso: $segundos segundos',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  _editarAtributos(item);
                                                },
                                                icon: const Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  _eliminar(item);
                                                },
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox(); // Agregar otro tipo de widget si es necesario
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _mostrarSeleccionarEjercicio();
                      },
                      child: const Text('Agregar ejercicio'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _agregarDescanso();
                      },
                      child: const Text('Agregar descanso'),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text('¿Es pública?'),
                  value: _esPublica,
                  onChanged: (value) {
                    setState(() {
                      _esPublica = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _crearSerie();
                  },
                  child: const Text('Crear serie'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadExerciseSelect() async {
    try {
      if (widget.ejercicioId != null) {
        final exercise = await ExerciseService.obtenerEjercicioPorId(
            context, widget.ejercicioId!);
        setState(() {
          if (exercise != null) {
            _configurarEjercicio(exercise);
          }
          //_exercise = exercise;
        });
      }
    } catch (error) {
      print('Error loading exercise: $error');
    }
  }

  void _mostrarSeleccionarEjercicio() async {
    final exercise = await showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      enableDrag: false,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.96,
          child: AllExercisePage(
            agregar: true,
          ),
        );
      },
    );

    if (exercise != null) {
      _configurarEjercicio(exercise);
    }
  }

  void _configurarEjercicio(Exercise exercise) {
    String?
        selectedEquipment; // Variable para almacenar el equipamiento seleccionado
    int repeticiones = 0;

    showModalBottomSheet(
      context: context,
      // backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      enableDrag: false,
      isScrollControlled:
          true, // Permite el desplazamiento cuando el teclado aparece
      builder: (context) {
        return SingleChildScrollView(
          // Envuelve el contenido con SingleChildScrollView
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configurar Ejercicio',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(exercise.name),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Repeticiones'),
                  onChanged: (value) {
                    repeticiones = int.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Equipamiento:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    //labelText: 'Equipo',
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color.fromARGB(255, 18, 18, 18),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.white), // Color del borde
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedEquipment,
                  onChanged: (String? value) {
                    setState(() {
                      selectedEquipment = value!;
                    });
                  },
                  dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                  items: exercise.equipment.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                            color: Colors
                                .white), // Establece el color del texto en blanco
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _agregarEjercicio(
                            exercise,
                            repeticiones,
                            selectedEquipment ??
                                ''); // Pasar el equipamiento seleccionado al método _agregarEjercicio
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verinformacionItem(Map<String, dynamic> item) async {
    await showModalBottomSheet(
      context: context,
      enableDrag: false,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        if (item.containsKey('exercise')) {
          // Ejercicio
          Map<String, dynamic> ejercicio = item['exercise'];
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text('Nombre: $nombreEjercicio'),
                    const SizedBox(height: 10),
                    Text('Repeticiones: $repeticiones'),
                    const SizedBox(height: 10),
                    Text('Equipamiento: $equipamiento'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _editarAtributos(item);
                      },
                      child: const Text('Editar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (item.containsKey('descanso')) {
          // Descanso
          int segundos = item['descanso'];

          return FractionallySizedBox(
            widthFactor: 1.0, // Ajustar al ancho de la pantalla
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información del Descanso',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text('Duración (segundos): $segundos'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _editarAtributos(item);
                      },
                      child: const Text('Editar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _agregarEjercicio(
      Exercise exercise, int repeticiones, String selectedEquipment) {
    _ejercicios.add({
      'exercise': {
        'nombre': exercise.name.toString(),
        'repetitions': repeticiones,
        'equipmentList': exercise.equipment,
        'equipmentSelect': selectedEquipment,
        'focusLevels': exercise.focusLevels 

        // Aquí puedes agregar más atributos de exercise según sea necesario
      }
    });
    setState(() {});
  }

  void _agregarDescanso() {
    showDialog(
      context: context,
      builder: (context) {
        int segundos = 0;

        return AlertDialog(
          title: const Text('Agregar Descanso'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Segundos'),
            onChanged: (value) {
              segundos = int.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _ejercicios.add({'descanso': segundos});
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

void _crearSerie() {
  if (_formKey.currentState!.validate()) {
    // Variables para almacenar la suma de los enfoques de los músculos
    Map<String, int> muscleFocusSum = {};

    // Filtrar solo los ejercicios dentro de _ejercicios
    List<Map<String, dynamic>> ejercicios = _ejercicios.where((item) => item.containsKey('exercise')).toList();

    // Calcular la suma de los enfoques de los músculos para cada ejercicio
    for (var ejercicio in ejercicios) {
      Map<String, dynamic> exercise = ejercicio['exercise'];
      Map<String, int> focusLevels = exercise['focusLevels'];
      focusLevels.forEach((muscle, focus) {
        muscleFocusSum.update(muscle, (value) => value + focus, ifAbsent: () => focus);
      });
    }

    // Ordenar los músculos por su enfoque sumado en orden descendente
    List<MapEntry<String, int>> sortedMuscleFocusSum = muscleFocusSum.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Establecer el enfoque primario y secundario
    String primaryFocus = sortedMuscleFocusSum.isNotEmpty ? sortedMuscleFocusSum[0].key : '';
    String secondaryFocus = sortedMuscleFocusSum.length > 1 ? sortedMuscleFocusSum[1].key : '';
    String thirdFocus = sortedMuscleFocusSum.length > 1 ? sortedMuscleFocusSum[2].key : '';

     Map<String, int> _focusLevels = {primaryFocus: 3, secondaryFocus: 2, thirdFocus: 1};

    
    // Determinar el tipo de serie 
      String tipoSerie = '';
      int cantidadEjercicios = ejercicios.length;
      if (cantidadEjercicios == 1) {
        tipoSerie = 'Serie simple';
      } else if (cantidadEjercicios == 2) {
        tipoSerie = 'Biseries';
      } else if (cantidadEjercicios == 3) {
        tipoSerie = 'Triseries';
      } else if (cantidadEjercicios == 3) {
        tipoSerie = 'Superserie';
      }


     Globales globales = Provider.of<Globales>(context, listen: false);

    // Crear el objeto WorkoutSeries
    WorkoutSeries serie = WorkoutSeries(
      name: _nombreController.text,
      nick: globales.nick, 
      isPublic: _esPublica,
      primaryFocus: primaryFocus,
      secondaryFocus: secondaryFocus,
      description: _descripcionController.text,
      type: tipoSerie,
      sets: _sets,
      restBetweenSets: _descansoEntreSets,
      exercises: _ejercicios,
      focusLevels: _focusLevels
    );

    // Imprimir el objeto WorkoutSeries (solo para depuración)
    print(serie.primaryFocus);
    print(serie.secondaryFocus);

    SerieService.agregarSerie(context, serie);
  }
}


  void _editarAtributos(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        if (item.containsKey('exercise')) {
          Map<String, dynamic> ejercicio = item['exercise'];
          String nombreEjercicio = ejercicio['nombre'];
          int repeticiones = ejercicio['repetitions'];
          String equipamiento = ejercicio['equipmentSelect'];
          List<String> equipmentList = ejercicio['equipmentList'];

          return SingleChildScrollView(
            // Wrap the content with SingleChildScrollView
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar Ejercicio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nombre: ${nombreEjercicio}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Repeticiones:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextFormField(
                    initialValue: repeticiones.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      print("Nuevo valor de repeticiones: $value");
                      setState(() {
                        repeticiones = int.tryParse(value) ?? repeticiones;
                        item['exercise']['repetitions'] = repeticiones;
                        // if(cancelar == true) item['exercise']['repetitions'] = valorActualReps;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Equipamiento:',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(255, 18, 18, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: equipamiento,
                    onChanged: (String? value) {
                      print("Nuevo valor de equipo: $value");
                      setState(() {
                        equipamiento = value!;
                        item['exercise']['equipmentSelect'] = equipamiento;
                        // if(cancelar == true)  item['exercise']['equipmentSelect'] = valorActualEquipamiento;
                      });
                    },
                    dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                    items: equipmentList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          );
        } else if (item.containsKey('descanso')) {
          int segundos = item['descanso'];
          return SingleChildScrollView(
            // Wrap the content with SingleChildScrollView
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar Descanso',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Duración (segundos):',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextFormField(
                    initialValue: segundos.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        print("Nuevo valor de descanso: $value");

                        segundos = int.tryParse(value) ?? segundos;
                        item['descanso'] = segundos;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _eliminar(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        title: const Text('Eliminar'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este ejercicio?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _ejercicios.remove(item);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

//Variables
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  int _sets = 1;
  int _descansoEntreSets = 0;
  bool _esPublica = false;
  List<Map<String, dynamic>> _ejercicios = [];
}
