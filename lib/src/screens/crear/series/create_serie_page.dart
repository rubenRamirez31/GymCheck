import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/ejercicios/all_excercise_page.dart';
import 'package:gym_check/src/services/excercise_service.dart';
import 'package:gym_check/src/services/serie_service.dart';
import 'package:numberpicker/numberpicker.dart';
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
        iconTheme: const IconThemeData(
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
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLength: 25,
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la serie (max. 25 caracteres)',
                    labelStyle: const TextStyle(color: Colors.white),
                    counterStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre para la serie';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLength: 120,
                  maxLines: null,
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (max. 120 caracteres)',
                    labelStyle: TextStyle(color: Colors.white),
                    counterStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Lógica para mostrar información sobre sets
                        },
                        icon: const Icon(Icons.info, color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Sets: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 20, // Ancho deseado del NumberPicker
                        child: NumberPicker(
                          value: _sets,
                          minValue: 1,
                          maxValue: 10,
                          onChanged: (value) {
                            setState(() {
                              _sets = value;
                            });
                          },
                          textStyle: const TextStyle(color: Colors.white),
                          selectedTextStyle:
                              const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      IconButton(
                        onPressed: () {
                          // Lógica para mostrar información sobre el descanso entre sets
                        },
                        icon: const Icon(Icons.info, color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Descanso: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 20, // Ancho deseado del NumberPicker
                        child: NumberPicker(
                          value: _descansoEntreSets,
                          minValue: 0,
                          maxValue: 120,
                          onChanged: (value) {
                            setState(() {
                              _descansoEntreSets = value;
                            });
                          },
                          textStyle: const TextStyle(color: Colors.white),
                          selectedTextStyle:
                              const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                _ejercicios.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300, // Altura máxima de 300 píxeles
                          ),
                          child: ReorderableListView(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            children: _ejercicios.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final item = entry.value;
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
                                  key: ValueKey('$index'),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 83, 83, 83),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$nombreEjercicio: $repeticiones reps',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _editarAtributos(item);
                                              },
                                              color: Colors.white,
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _eliminar(item);
                                              },
                                              color: Colors.white,
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
                                  key: ValueKey('$index'),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 83, 83, 83),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Descanso: $segundos segundos',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                _editarAtributos(item);
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              color: Colors.white,
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
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final item = _ejercicios.removeAt(oldIndex);
                                _ejercicios.insert(newIndex, item);
                              });
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  title: const Text(
                    '¿Es pública?',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  value: _esPublica,
                  onChanged: (value) {
                    setState(() {
                      _esPublica = value!;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _crearSerie();
                      },
                      child: const Text('Crear serie'),
                    ),
                  ],
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

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configurar Ejercicio',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(exercise.name,
                      style: TextStyle(
                          color: Colors
                              .white)), // Establece el color del texto en blanco
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Repeticiones',
                      labelStyle: TextStyle(
                          color: Colors
                              .white), // Establece el color del texto de la etiqueta en blanco
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      repeticiones = int.tryParse(value) ?? 0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un número de repeticiones';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Equipamiento:',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors
                            .white), // Establece el color del texto en blanco
                  ),
                    const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Selecciona un equipamiento',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un equipamiento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar',
                            style: TextStyle(
                                color: Colors
                                    .white)), // Establece el color del texto en blanco
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _agregarEjercicio(
                                exercise,
                                repeticiones,
                                selectedEquipment ??
                                    ''); // Pasar el equipamiento seleccionado al método _agregarEjercicio
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Aceptar',
                            style: TextStyle(
                                color: Colors
                                    .black)), // Establece el color del texto en blanco
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _verinformacionItem(Map<String, dynamic> item) async {
    await showModalBottomSheet(
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
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text('Duración (segundos): $segundos',
                        style: const TextStyle(color: Colors.white)),
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
          backgroundColor: const Color.fromARGB(255, 18, 18, 18),
          title: const Text(
            'Agregar Descanso',
            style: TextStyle(
                color: Colors.white), // Cambia el color del texto a blanco
          ),
          content: TextFormField(
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Segundos',
              labelStyle: TextStyle(
                  color: Colors
                      .white), // Cambia el color del texto de la etiqueta a blanco
            ),
            onChanged: (value) {
              segundos = int.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                    color: Colors.white), // Cambia el color del texto a blanco
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _ejercicios.add({'descanso': segundos});
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(
                    color: Colors.black), // Cambia el color del texto a blanco
              ),
            ),
          ],
        );
      },
    );
  }

  void _crearSerie() {
    if (_formKey.currentState!.validate()) {
      // Mostrar AlertDialog con fondo negro y letras blancas mientras se crea la serie
      showDialog(
        context: context,
        barrierDismissible:
            false, // Impide que el usuario cierre el AlertDialog tocando fuera de él
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: Text(
              'Creando...',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Color del indicador de progreso blanco
            ),
          );
        },
      );

      // Variables para almacenar la suma de los enfoques de los músculos
      Map<String, int> muscleFocusSum = {};

      // Filtrar solo los ejercicios dentro de _ejercicios
      List<Map<String, dynamic>> ejercicios =
          _ejercicios.where((item) => item.containsKey('exercise')).toList();

      // Calcular la suma de los enfoques de los músculos para cada ejercicio
      for (var ejercicio in ejercicios) {
        Map<String, dynamic> exercise = ejercicio['exercise'];
        Map<String, int> focusLevels = exercise['focusLevels'];
        focusLevels.forEach((muscle, focus) {
          muscleFocusSum.update(muscle, (value) => value + focus,
              ifAbsent: () => focus);
        });
      }

      // Ordenar los músculos por su enfoque sumado en orden descendente
      List<MapEntry<String, int>> sortedMuscleFocusSum = muscleFocusSum.entries
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Establecer el enfoque primario y secundario
      String primaryFocus =
          sortedMuscleFocusSum.isNotEmpty ? sortedMuscleFocusSum[0].key : '';
      String secondaryFocus =
          sortedMuscleFocusSum.length > 1 ? sortedMuscleFocusSum[1].key : '';
      String thirdFocus =
          sortedMuscleFocusSum.length > 1 ? sortedMuscleFocusSum[2].key : '';

      Map<String, int> _focusLevels = {
        primaryFocus: 3,
        secondaryFocus: 2,
        thirdFocus: 1
      };

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
          focusLevels: _focusLevels);

      // Imprimir el objeto WorkoutSeries (solo para depuración)
      print(serie.primaryFocus);
      print(serie.secondaryFocus);

      SerieService.agregarSerie(context, serie);
      // Agregar un retraso de 2 segundos para simular la creación de la serie
      Future.delayed(Duration(seconds: 2), () {
        // Cerrar el AlertDialog de creación
        Navigator.of(context).pop();

        // Navegar a la página anterior
        Navigator.pop(context);

// Mostrar otro AlertDialog después de crear la serie
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.black, // Fondo negro
              title: Text(
                'Serie creada',
                style: TextStyle(color: Colors.white), // Letras blancas
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'La serie ha sido almacenada en la sección "Series", y puede encontrarla en "Creado por mí".',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Crear otra serie
                        },
                        child: Text('Crear otra serie',
                            style: TextStyle(
                                color: Colors.black)), // Letras blancas
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Crear rutina
                        },
                        child: Text('Crear rutina',
                            style: TextStyle(
                                color: Colors.black)), // Letras blancas
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      });
    }
  }

  void _editarAtributos(Map<String, dynamic> item) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nombre: ${nombreEjercicio}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Repeticiones:',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  TextFormField(
                    initialValue: repeticiones.toString(),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      //fillColor: const Color.fromARGB(255, 18, 18, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: Text('Seleccionar el Equipamiento'),
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Duración (segundos):',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  TextFormField(
                    initialValue: segundos.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(color: Colors.white),
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
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        title: const Text(
          'Eliminar',
          style: TextStyle(
              color: Colors.white), // Cambia el color del texto a blanco
        ),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este ejercicio?',
          style: TextStyle(
              color: Colors.white), // Cambia el color del texto a blanco
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                  color: Colors.white), // Cambia el color del texto a blanco
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _ejercicios.remove(item);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                  color: Colors.black), // Cambia el color del texto a blanco
            ),
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
