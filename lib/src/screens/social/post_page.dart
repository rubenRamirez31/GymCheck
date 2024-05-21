import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/values/app_colors.dart';

class PublicacionPage extends StatefulWidget {
  final String postid;
  const PublicacionPage({super.key, required this.postid});

  @override
  State<PublicacionPage> createState() => _PublicacionPageState();
}

class _PublicacionPageState extends State<PublicacionPage> {
  @override
  Widget build(BuildContext context) {
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
            },
          ),
          backgroundColor: AppColors.darkestBlue,
          title: const Text(
            'Publicación',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<Post>(
          future: obtenerPublicacion(widget.postid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Título: ${snapshot.data!.nick}'),
                Text('Contenido: ${snapshot.data!.texto}'),
                // Otros detalles de la publicación...
              ],
            );
          },
        ));
  }

  // Método para obtener la publicación asociada al identificador recibido
  Future<Post> obtenerPublicacion(String postId) async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Publicaciones')
        .doc(postId)
        .get();
    return Post.fromJson(postSnapshot.data() as Map<String, dynamic>);
  }
}
