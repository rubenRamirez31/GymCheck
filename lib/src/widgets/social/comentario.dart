import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/widgets/social/nick.dart';
import '../../models/social/comentario.dart';

class ComentarioCard extends StatefulWidget {
  final Comentario comentario;
  const ComentarioCard({super.key, required this.comentario});

  @override
  State<ComentarioCard> createState() => _ComentarioCardState();
}

class _ComentarioCardState extends State<ComentarioCard> {
  String? userProfileImageUrl;

  @override
  void initState() {
    // TODO: implement initState
    getUserProfileImageUrl(widget.comentario.userId);
  }

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
                  child: userProfileImageUrl != null &&
                          userProfileImageUrl!.isNotEmpty
                      ? CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(userProfileImageUrl!),
                        )
                      : const CircleAvatar(
                          radius: 25,
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
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [Nick(userId: widget.comentario.userId)],
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: Text(widget.comentario.comentario)),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  Future<void> getUserProfileImageUrl(String userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where("userIdAuth", isEqualTo: userId)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        // Verificar si el objeto es un mapa antes de verificar si contiene la clave
        if (userData is Map && userData.containsKey('urlImagen')) {
          if (mounted) {
            // Verificar si el widget está montado antes de llamar a setState
            setState(() {
              userProfileImageUrl = userData['urlImagen'];
            });
          }
        }
      }
    } catch (e) {
      print('Error al obtener la foto de perfil del usuario: $e');
    }
  }
}
