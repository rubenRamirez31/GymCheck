import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
import 'package:gym_check/src/screens/crear/widgets/create_widgets.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/services/excercise_service.dart';

class ViewExercisePage extends StatefulWidget {
  final String id;
  final bool buttons; //mostrar botones

  const ViewExercisePage({Key? key, required this.id, required this.buttons})
      : super(key: key);

  @override
  _ViewExercisePageState createState() => _ViewExercisePageState();
}

class _ViewExercisePageState extends State<ViewExercisePage> {
  Exercise? _exercise;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadExercise();
    _loadFavoriteStatus();
  }

  Future<void> _loadExercise() async {
    try {
      final exercise =
          await ExerciseService.obtenerEjercicioPorId(context, widget.id);
      setState(() {
        _exercise = exercise;
      });
    } catch (error) {
      print('Error loading exercise: $error');
      // Manejo de error si es necesario
    }
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final bool isFavorite =
          await ExerciseService.esFavorito(context, widget.id);
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
        await ExerciseService.agregarAFavoritos(context, _exercise!);
      } else {
        await ExerciseService.quitarDeFavoritos(context, widget.id);
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      body: _exercise != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildImage(),
                        const SizedBox(height: 10),
                        if(widget.buttons == true)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // color: const Color.fromARGB(255, 30, 30, 30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RawMaterialButton(
                                  onPressed: _toggleFavoriteStatus,
                                  fillColor: Colors.grey[200],
                                  shape: const CircleBorder(),
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CrearSeriePage(
                                                ejercicioId: widget.id,
                                              )),
                                    );
                                  },
                                  fillColor: Colors.grey[200],
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.playlist_add,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            _exercise!.name, MainAxisAlignment.center),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                            "Enfoque principal:", _exercise!.primaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRow(
                            "Enfoque secundario:", _exercise!.secondaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            "Descripción:", MainAxisAlignment.center),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelGeneral(
                            _exercise!.description, 14),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        CreateWidgets.buildLabelGeneralList(
                            _exercise!.equipment, 14),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          onPressed: () {},
                          text: 'Ver video',
                          icon: Icons.play_arrow,
                        ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      width: 200,
      height: 200,
      child: _exercise!.representativeImageLink.isNotEmpty
          ? Image.network(
              _exercise!.representativeImageLink,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const CircularProgressIndicator();
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Text('Error cargando la imagen');
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
            )
          : const Center(
              child: Text('Imagen no encontrada'),
            ),
    );
  }
}
