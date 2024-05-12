import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gym_check/src/models/social/notificaciones.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/social/notificacion.dart';
import 'package:provider/provider.dart';

class NotificatoinsPage extends StatefulWidget {
  const NotificatoinsPage({super.key});

  @override
  State<NotificatoinsPage> createState() => _NotificatoinsPageState();
}

class _NotificatoinsPageState extends State<NotificatoinsPage> {
  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();

    final Stream<QuerySnapshot> notificacionesStream = FirebaseFirestore
        .instance
        .collection("Notificaciones")
        .where("destinatario", isEqualTo: globales.correo)
        .orderBy("fechaCreacion", descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: AppColors.white,
          ), // Icono de una equis
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.darkestBlue,
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: notificacionesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((e) {
                    Notificacion n = Notificacion.getFirebaseId(
                        e.id, e.data() as Map<String, dynamic>);
                    return NotificationCard(notificacion: n);
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
