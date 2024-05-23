import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class RutinaCardCreatePage extends StatefulWidget {
  final Workout workout;
  const RutinaCardCreatePage({super.key, required this.workout});

  @override
  State<RutinaCardCreatePage> createState() => _RutinaCardCreatePageState();
}

class _RutinaCardCreatePageState extends State<RutinaCardCreatePage> {
  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
    return Column(
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  widget.workout.urlImagen.isNotEmpty
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.workout.urlImagen,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
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
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                              headers: const {
                                'Accept': '*/*',
                                'User-Agent': 'your_user_agent',
                              },
                              fit: BoxFit
                                  .cover, // Ajusta la imagen al tamaño del contenedor
                            ),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
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
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align texts left
                                children: [
                                  Text(
                                    widget.workout.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Truncate long text with ellipsis
                                  ),
                                  Text(
                                    "${widget.workout.primaryFocus}, ${widget.workout.secondaryFocus}, ${widget.workout.thirdFocus}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    globales.nick == widget.workout.nick
                                        ? "Creada por: tí"
                                        : "Creada por:${widget.workout.nick}",
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (globales.rutinas.isNotEmpty) {
                          globales.quitarRutina();
                          SmartDialog.showToast(
                            "Rutina removida de la publicacion",
                            displayTime: const Duration(seconds: 2),
                          );
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
