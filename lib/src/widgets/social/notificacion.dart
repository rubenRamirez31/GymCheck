import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/social/notificaciones.dart';

class NotificationCard extends StatefulWidget {
  final Notificacion notificacion;
  const NotificationCard({super.key, required this.notificacion});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  String? userProfileImageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfileImageUrl(widget.notificacion.remitente);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.notificacion.visto
        ? const TextStyle(fontSize: 16)
        : const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return InkWell(
      onTap: () {
        // Acción al hacer clic en la tarjeta
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    Positioned(
                      top: 38,
                      left: 38,
                      child: Icon(
                        getIconForNotificationType(widget.notificacion.tipo),
                        color: getColorForNotificationType(
                            widget.notificacion.tipo),
                        size: 23,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notificacion.remitente,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      widget.notificacion.contenido,
                      style: textStyle,
                    ),
                    Text(
                      // ignore: unnecessary_null_comparison
                      widget.notificacion.fecha != null
                          ? formatRelativeTime(widget.notificacion.fecha)
                          : 'Fecha no disponible',
                      style: widget.notificacion.visto
                          ? const TextStyle(color: Colors.grey)
                          : const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
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

  Future<void> getUserProfileImageUrl(String nick) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where("nick", isEqualTo: nick)
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

  IconData getIconForNotificationType(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comentario':
        return Icons.comment;
      case 'publicacion':
        return Icons.article;
      default:
        return Icons.notification_important; // Icono por defecto para otro tipo
    }
  }

  Color getColorForNotificationType(String tipo) {
    switch (tipo) {
      case 'like':
        return Colors.red;
      case 'comentario':
        return Colors.green;
      case 'publicacion':
        return Colors.blue;
      default:
        return Colors.grey; // Color gris por defecto
    }
  }
}
