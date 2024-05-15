import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
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

  @override
  void initState() {
    super.initState();
    _loadExercise();
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
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRowOnly(
                          _exercise!.name,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRow(
                            "Enfoque principal:", _exercise!.primaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRow(
                            "Enfoque secundario:", _exercise!.secondaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRowOnly("Descripción:"),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelGeneral(_exercise!.description, 14),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelGeneralList(_exercise!.equipment, 14),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print(
                                'Agrega a rutina'); // Mensaje a imprimir en la consola
                          },
                          child: Text('Ver video explicativo'),
                        )
                      ],
                    ),
                  ),
                ),
                if (widget.buttons == true)
                  Positioned(
                    top: 80,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xff0C1C2E),
                      tooltip: "hola",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrearSeriePage(
                                    ejercicioId: widget.id,
                                  )),
                        );
                      },
                      child: Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (widget.buttons  == true)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xff0C1C2E),
                      onPressed: () {
                        // Lógica para agregar a favoritos
                        print('Agregar a favoritos');
                      },
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
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

  Widget _buildLabelDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelDetailsRowOnly(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelGeneral(String label, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelGeneralList(List<String> equipment, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        child: ExpansionTile(
          backgroundColor: Colors
              .transparent, // Fondo transparente para evitar duplicar el color del contenedor
          title: Text(
            '¿Con qué equipo se puede realizar?',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          children: [
            for (var item in equipment)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  item,
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
