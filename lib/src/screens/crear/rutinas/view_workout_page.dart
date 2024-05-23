// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/series/view_serie_page.dart';
import 'package:gym_check/src/screens/crear/widgets/create_widgets.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';
import 'package:gym_check/src/services/serie_service.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:provider/provider.dart';

class ViewWorkoutPage extends StatefulWidget {
  final String id;
  final bool buttons; // Whether to show action buttons

  const ViewWorkoutPage({Key? key, required this.id, required this.buttons})
      : super(key: key);

  @override
  _ViewWorkoutPageState createState() => _ViewWorkoutPageState();
}

class _ViewWorkoutPageState extends State<ViewWorkoutPage> {
  Workout? _workout;

  @override
  void initState() {
    super.initState();
    _loadWorkoutSeries();
  }

  Future<void> _loadWorkoutSeries() async {
    try {
      final workoutSeries =
          await RutinaService.obtenerRutinaPorId(context, widget.id);
      setState(() {
        _workout = workoutSeries;
      });
    } catch (error) {
      print('Error loading workout series: $error');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    Globales globales = Provider.of<Globales>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      body: _workout != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildImage(),
                        //const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Rutina creada por',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Acción del botón
                              },
                              child: Text(
                                _workout!.nick,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.buttons == true) const SizedBox(height: 10),
                        if (widget.buttons == true)
                          CustomButton(
                            onPressed: () {},
                            text: 'Iniciar rutina',
                            icon: Icons.play_arrow,
                          ),
                        const SizedBox(height: 10),
                        if (widget.buttons == true)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //color: const Color.fromARGB(255, 30, 30, 30),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {
                                      // Lógica para agregar a favoritos
                                      print('Agregar a favoritos');
                                    },
                                    fillColor: Colors.grey[200],
                                    shape: const CircleBorder(),
                                    child: const Icon(Icons.favorite_border,
                                        color: Colors.black),
                                  ),
                                  if (_workout?.nick == globales.nick)
                                    RawMaterialButton(
                                      onPressed: () {
                                        // Lógica para editar
                                        print('Editar');
                                      },
                                      fillColor: Colors.grey[200],
                                      shape: const CircleBorder(),
                                      child: const Icon(Icons.edit,
                                          color: Colors.black),
                                    ),
                                  if (_workout?.isPublic == true)
                                    RawMaterialButton(
                                      onPressed: () {
                                        // Lógica para editar
                                        print('Editar');
                                      },
                                      fillColor: Colors.grey[200],
                                      shape: const CircleBorder(),
                                      child: const Icon(Icons.share,
                                          color: Colors.black),
                                    ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddReminderPage(
                                                    tipo: "Rutina",
                                                    rutinaId: widget.id)),
                                      );

                                      //AddReminderPage(tipo: "Rutina",rutinaId: widget.id);
                                      // Lógica para editar
                                      print('Editar');
                                    },
                                    fillColor: Colors.grey[200],
                                    shape: const CircleBorder(),
                                    child: const Icon(Icons.timer_outlined,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRowOnly(
                          _workout!.name,
                          MainAxisAlignment.center,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            "Grupos musculares que trabaja:",
                            MainAxisAlignment.center),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CreateWidgets.buildLabelDetailsRowOnly(
                                  _workout!.primaryFocus,
                                  MainAxisAlignment.start,
                                  ajustar: MainAxisSize.min),
                              const SizedBox(
                                width: 20,
                              ),
                              CreateWidgets.buildLabelDetailsRowOnly(
                                  _workout!.secondaryFocus,
                                  MainAxisAlignment.start,
                                  ajustar: MainAxisSize.min),
                              const SizedBox(
                                width: 20,
                              ),
                              CreateWidgets.buildLabelDetailsRowOnly(
                                  _workout!.thirdFocus, MainAxisAlignment.start,
                                  ajustar: MainAxisSize.min),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            "Contenido de la rutina:",
                            MainAxisAlignment.center),
                        const SizedBox(height: 10),
                        _buildSeriesList(),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRow(
                            "Descansos series sets(segundos):",
                            _workout!.restBetweenSets.toString()),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _workout!.urlImagen,
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
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
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
    );
  }

  Widget _buildSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _workout!.series.map((serie) {
        return GestureDetector(
          onTap: () async {
            final serieId = serie['serie']['id'];
            final serieExist =
                await SerieService.obtenerSeriePorId(context, serieId);

            if (serieExist != null) {
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
                    child: ViewWorkoutSeriesPage(id: serieId, buttons: true),
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¡Serie no disponible!'),
                  content: const Text(
                      'Esta serie ya no está disponible. Esto suele suceder cuando el propietario de la serie la ha eliminado.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  serie['serie']['nombre'] ?? 'Serie no disponible',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
