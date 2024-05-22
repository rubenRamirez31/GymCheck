import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/series/all_series_page.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/screens/crear/series/view_serie_page.dart';
import 'package:gym_check/src/services/serie_service.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:provider/provider.dart';

class CrearWorkoutPage extends StatefulWidget {
  final String? serieID;

  const CrearWorkoutPage({Key? key, this.serieID}) : super(key: key);

  @override
  _CrearWorkoutPageState createState() => _CrearWorkoutPageState();
}

class _CrearWorkoutPageState extends State<CrearWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  int _descansoEntreSeries = 0;
  bool _esPublica = false;
  List<Map<String, dynamic>> _series = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadSerieSelect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Crear Rutina',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  //onTap: print("d"),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLength: 25,
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la rutina (max. 25 caracteres)',
                    counterStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre para la rutina';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  maxLength: 120,
                  controller: _descripcionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de la rutina (max. 120 caracteres)',
                    counterStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción para la rutina';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descanso entre series (segundos)',
                    counterStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _descansoEntreSeries = int.tryParse(value) ?? 0;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                  const SizedBox(height: 15),
                _series.isNotEmpty
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
                            children: _series.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final item = entry.value;
                              if (item.containsKey('serie')) {
                                String idSerie = item['serie']['id'];
                                String nombre = item['serie']['nombre'];
                                return GestureDetector(
                                  onTap: () {
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
                                          child: ViewWorkoutSeriesPage(
                                              id: idSerie, buttons: false),
                                        );
                                      },
                                    );
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
                                          'Nombre: $nombre',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _eliminar(item);
                                          },
                                          icon: const Icon(Icons.delete),
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (item.containsKey('descanso')) {
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
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Descanso: $segundos segundos',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _eliminar(item);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            }).toList(),
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final item = _series.removeAt(oldIndex);
                                _series.insert(newIndex, item);
                              });
                            },
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _mostrarSeleccionarSeries();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 300,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 18, 18, 18),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 0.5),
                          ),
                          child: const Center(
                            child: Text(
                              'Agregar una serie',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _mostrarSeleccionarSeries();
                      },
                      child: const Text('Seleccionar serie'),
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
                        _crearRutina();
                      },
                      child: const Text('Crear Rutina'),
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

  Future<void> _loadSerieSelect() async {
    print(widget.serieID);
    try {
      if (widget.serieID != null) {
        final serie =
            await SerieService.obtenerSeriePorId(context, widget.serieID!);
        setState(() {
          if (serie != null) {
            _agregarSerie(serie);
            print(serie);
          }
          //_exercise = exercise;
        });
      }
    } catch (error) {
      print('Error loading exercise: $error');
    }
  }

  void _mostrarSeleccionarSeries() async {
    final serie = await showModalBottomSheet(
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
        // Aquí puedes implementar la lógica para mostrar una lista de series disponibles
        return const FractionallySizedBox(
          heightFactor: 0.96,
          child: AllSeriePage(
            agregar: true,
          ),
        );
      },
    );

    if (serie != null) {
      _agregarSerie(serie);
    }
  }

  void _agregarSerie(WorkoutSeries serie) {
    _series.add({
      'serie': {'id': serie.id, 'nombre': serie.name}
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
                _series.add({'descanso': segundos});
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

  Future<bool> _tieneSeriePrivada() async {
    for (var serieItem in _series) {
      if (serieItem.containsKey('serie')) {
        String serieId = serieItem['serie']['id'];
        try {
          final serie = await SerieService.obtenerSeriePorId(context, serieId);
          if (serie != null && !serie.isPublic) {
            return true;
          }
        } catch (error) {
          print('Error obtaining series: $error');
        }
      }
    }
    return false;
  }

  void _crearRutina() async {
    if (_formKey.currentState!.validate()) {
      Globales globales = Provider.of<Globales>(context, listen: false);
      // Verificar si hay series privadas
      bool tieneSeriePrivada = await _tieneSeriePrivada();

      // Mostrar AlertDialog mientras se crea la rutina
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
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

      // Obtener los enfoques de las series asociadas
      for (var serieItem in _series) {
        String serieId = serieItem['serie']['id'];
        try {
          final serie = await SerieService.obtenerSeriePorId(context, serieId);
          if (serie != null) {
            // Sumar los enfoques de los músculos de la serie actual
            serie.focusLevels.forEach((muscle, focus) {
              muscleFocusSum.update(muscle, (value) => value + focus,
                  ifAbsent: () => focus);
            });
          }
        } catch (error) {
          print('Error obtaining series: $error');
        }
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
          sortedMuscleFocusSum.length > 2 ? sortedMuscleFocusSum[2].key : '';

      // Crear el objeto Workout
      Workout rutina = Workout(
        name: _nombreController.text,
        nick: globales.nick,
        isPublic: _esPublica,
        primaryFocus: primaryFocus,
        secondaryFocus: secondaryFocus,
        thirdFocus: thirdFocus,
        description: _descripcionController.text,
        type: '', // Asignar los valores apropiados
        restBetweenSets: _descansoEntreSeries,
        series: _series,
      );

      // Si hay series privadas y la rutina es pública, mostrar un mensaje de advertencia
      if (tieneSeriePrivada && _esPublica) {
        Navigator.of(context).pop(); // Cerrar el AlertDialog de creación
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Advertencia'),
            content: const Text(
                'Una o más series asociadas a esta rutina son privadas. '
                'Si haces esta rutina pública, las series también se volverán públicas. '
                '¿Deseas continuar?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cerrar el AlertDialog de advertencia
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cerrar el AlertDialog de advertencia

                  // Convertir las series privadas en públicas
                  for (var serieItem in _series) {
                    if (serieItem.containsKey('serie')) {
                      String serieId = serieItem['serie']['id'];
                      SerieService.modificarVisibilidadSerie(
                          context, serieId, true);
                    }
                  }

                  _crearRutina(); // Llamar de nuevo a la función para crear la rutina
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
        return; // Salir de la función para evitar crear la rutina en este momento
      }

      RutinaService.agregarRutina(context, rutina);
      // Simular un retraso de 2 segundos para la creación de la rutina
      await Future.delayed(const Duration(seconds: 2));

      // Cerrar el AlertDialog de creación
      Navigator.of(context).pop();
      // Navegar a la página anterior
      Navigator.pop(context);

      // Mostrar AlertDialog después de crear la rutina
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Rutina creada',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'La rutina ha sido almacenada en la sección "Rutinas", y puede encontrarla en "Creado por mí".',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Crear otra rutina
                  },
                  child: const Text('Crear otra rutina',
                      style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Ver todas las rutinas
                  },
                  child: const Text('Ver todas las rutinas',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _eliminar(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este elemento?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _series.remove(item);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
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
        if (item.containsKey('descanso')) {
          int segundos = item['descanso'];
          return FractionallySizedBox(
            widthFactor: 1.0,
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

  void _editarAtributos(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      // backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      enableDrag: false,
      isScrollControlled:
          true, // Permite el desplazamiento cuando el teclado aparece
      builder: (context) {
        if (item.containsKey('descanso')) {
          int segundos = item['descanso'];
          return SingleChildScrollView(
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
}
