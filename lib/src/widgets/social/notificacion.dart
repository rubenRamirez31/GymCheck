import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/notificaciones.dart';

class NotificationCard extends StatefulWidget {
  final Notificacion notificacion;
  const NotificationCard({super.key, required this.notificacion});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.notificacion.remitente)
        ],
      ),
    );
  }
}
