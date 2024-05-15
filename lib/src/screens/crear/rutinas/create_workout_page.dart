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

  @override
  void initState() {
    super.initState();
    _loadSerieSelect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rutina'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la rutina'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre para la rutina';
                    }
                    return null;
                  },
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Descanso entre series (segundos)'),
                  onChanged: (value) {
                    setState(() {
                      _descansoEntreSeries = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _series.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300, // Altura máxima de 300 píxeles
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _series.map((item) {
                                if (item.containsKey('serie')) {
                                  String idSerie = item['serie']['id'];
                                  String nombre = item['serie']['nombre'];
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: const Color.fromARGB(
                                            255, 18, 18, 18),
                                        scrollControlDisabledMaxHeightRatio:
                                            0.9,
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
                                            'Nombre: $nombre',
                                            style:
                                                const TextStyle(fontSize: 16),
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
                                } else if (item.containsKey('descanso')) {
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
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _mostrarSeleccionarSeries();
                      },
                      child: Text('Seleccionar serie'),
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
                    _crearRutina();
                  },
                  child: const Text('Crear Rutina'),
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

  void _crearRutina() async {
    if (_formKey.currentState!.validate()) {
      Globales globales = Provider.of<Globales>(context, listen: false);

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

      print(primaryFocus);
      print(secondaryFocus);
      print(thirdFocus);
      // Llamar al servicio para agregar la rutina
       RutinaService.agregarRutina(context, rutina);
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
