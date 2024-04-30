import 'package:flutter/material.dart';
import '../../models/social/comentario.dart';

class ComentarioCard extends StatefulWidget {
  final Comentario comentario;
  const ComentarioCard({super.key, required this.comentario});

  @override
  State<ComentarioCard> createState() => _ComentarioCardState();
}

class _ComentarioCardState extends State<ComentarioCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 241, 246),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(widget.comentario.comentario),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          // ignore: unnecessary_null_comparison
                          widget.comentario.fechaCreacion != null
                              ? formatRelativeTime(
                                  widget.comentario.fechaCreacion)
                              : 'Fecha no disponible',
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

  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'hace unos segundos';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes min';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours h';
    } else {
      final days = difference.inDays;
      return '$days d';
    }
  }
}
