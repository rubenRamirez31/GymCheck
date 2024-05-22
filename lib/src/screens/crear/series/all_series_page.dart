import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/screens/crear/series/view_serie_page.dart';

import 'package:gym_check/src/services/serie_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllSeriePage extends StatefulWidget {
  final bool agregar;

  const AllSeriePage({Key? key, required this.agregar}) : super(key: key);

  @override
  _AllSeriePageState createState() => _AllSeriePageState();
}

class _AllSeriePageState extends State<AllSeriePage> {
  late Stream<List<WorkoutSeries>> _serieStream;
  TextEditingController _searchController = TextEditingController();
  int _selectedMenuOption = 0;
  String? _selectedEnfoque;

  List<String> options = [
    'Creados por mi',
    'Todo',
    'Favoritos',
  ];
  List<Color> highlightColors = [
    const Color.fromARGB(255, 94, 24, 246),
    const Color.fromARGB(255, 94, 24, 246),
    const Color.fromARGB(255, 94, 24, 246),
  ];

  @override
  void initState() {
    super.initState();
    _serieStream = obtenerTodasSeriesStream();
  }

  Stream<List<WorkoutSeries>> _getSeriesStreamForOption(int option) {
    switch (option) {
      case 0:
        return obtenerSeriesFiltradasStream(_searchController.text,
            cradospormi: true, todo: false);
      case 1:
        return obtenerSeriesFiltradasStream(_searchController.text,
            cradospormi: false, todo: true);
      case 2:
        return obtenerSeriesFiltradasStream(_searchController.text,
            cradospormi: false, todo: false);
      default:
        return obtenerTodasSeriesStream();
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
                          _serieStream =
                              _getSeriesStreamForOption(_selectedMenuOption);
                        });
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
                labelText: 'Buscar serie',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _serieStream = obtenerSeriesFiltradasStream(query,
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
                              _serieStream = _getSeriesStreamForOption(
                                  _selectedMenuOption);
                            });
                          },
                          items: <String>[
                            'Pecho',
                            'Espalda',
                            'Bicep',
                            'Cuadricep',
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
                            _serieStream =
                                _getSeriesStreamForOption(_selectedMenuOption);
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
            StreamBuilder<List<WorkoutSeries>>(
              stream: _serieStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final series = snapshot.data!;
                  return Column(
                    children: series.map((serie) {
                      return SerieContainer(
                        serie: serie,
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

  Stream<List<WorkoutSeries>> obtenerTodasSeriesStream() {
    try {
      final seriesStream = SerieService.obtenerTodasSeriesStream(context);
      return seriesStream;
    } catch (error) {
      print('Error al obtener todas las series: $error');
      throw error;
    }
  }

  Stream<List<WorkoutSeries>> obtenerSeriesFiltradasStream(String query,
      {required bool cradospormi, required bool todo}) {
    try {
      final seriesStream = SerieService.obtenerSeriesFiltradasStream(
          context, query, cradospormi, todo,
          enfoque: _selectedEnfoque);
      return seriesStream;
    } catch (error) {
      print('Error al obtener las series filtradas: $error');
      throw error;
    }
  }
}

class SerieContainer extends StatefulWidget {
  final WorkoutSeries serie;
  final bool agregar;

  const SerieContainer({Key? key, required this.serie, required this.agregar})
      : super(key: key);

  @override
  _SerieContainerState createState() => _SerieContainerState();
}

class _SerieContainerState extends State<SerieContainer> {
  bool _isFavorite =
      false; // Estado para controlar si la serie está marcada como favorita

  @override
  Widget build(BuildContext context) {
    String primary = widget.serie.primaryFocus;
    String secondary = widget.serie.secondaryFocus;

    return GestureDetector(
      onTap: () {
        if (widget.agregar == true) {
          Navigator.of(context).pop(widget.serie);
        } else {
          //agregar algo aquí
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
                  if (widget.agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.serie.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                                : Icons
                                    .favorite_border, // Cambiar el ícono según el estado de favorito
                            color: _isFavorite
                                ? Colors.red
                                : Colors
                                    .grey, // Cambiar el color del ícono según el estado de favorito
                          ),
                        ),
                      ],
                    ),
                  if (widget.agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.serie.primaryFocus,
                          style: const TextStyle(
                           
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
                                  child: ViewWorkoutSeriesPage(
                                      id: widget.serie.id ?? "",
                                      buttons: false),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.info,
                          ),
                        ),
                      ],
                    ),
                  if (widget.agregar == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.serie.name,
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
                                  child: ViewWorkoutSeriesPage(
                                      id: widget.serie.id ?? "",
                                      buttons: false),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.more_horiz,
                          ),
                        ),
                      ],
                    ),
                  if (widget.agregar == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.serie.primaryFocus,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
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
                                : Icons
                                    .favorite_border, // Cambiar el ícono según el estado de favorito
                            color: _isFavorite
                                ? Colors.red
                                : Colors
                                    .grey, // Cambiar el color del ícono según el estado de favorito
                          ),
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
