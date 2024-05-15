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

  List<String> options = [
    'Todo',
    'Creados por mi',
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
    _serieStream = obtenerTodasSeriesStream();
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
                labelText: 'Buscar serie',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _serieStream = obtenerSeriesFiltradasStream(query);
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

  Stream<List<WorkoutSeries>> obtenerSeriesFiltradasStream(String query) {
    try {
      final seriesStream =
          SerieService.obtenerSeriesFiltradasStream(context, query);
      return seriesStream;
    } catch (error) {
      print('Error al obtener las series filtradas: $error');
      throw error;
    }
  }
}

class SerieContainer extends StatelessWidget {
  final WorkoutSeries serie;
  final bool agregar;

  const SerieContainer({Key? key, required this.serie, required this.agregar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String primary = serie.primaryFocus;
    String secondary = serie.secondaryFocus;

    return GestureDetector(
      onTap: () {
        if (agregar == true) {
          Navigator.of(context).pop(serie);
        } else {
          //agregar algop aqui
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
                  if (agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          serie.name,
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
                                  child: ViewWorkoutSeriesPage(
                                      id: serie.id ?? "", buttons: false),
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
                          serie.name,
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
                                      id: serie.id ?? "", buttons: true),
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
