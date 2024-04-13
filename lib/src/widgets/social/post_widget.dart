import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/screens/social/edit_post_page.dart';

import 'package:gym_check/src/screens/social/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';

class PostHeader extends StatelessWidget {
  final String nick;
  final String postUserId;

  final bool editado;
  final String postId;

  const PostHeader({
    Key? key,
    required this.nick,
    required this.postUserId,
    required this.editado,
    required this.postId,
  }) : super(key: key);

  String getEstadoAbreviado(String estado) {
    switch (estado) {
      case 'Iniciado':
        return 'IN';
      case 'Visto':
        return 'V';
      case 'En Proceso':
        return 'EP';
      case 'Concluido':
        return 'C';
      case 'Rechazado':
        return 'R';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(nick: nick)),
            );
          },
          child: Text(
            nick,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Spacer(),
        if (isEdited(editado))
         Text("Editado"),

        // IconButton(
        //   icon: Icon(Icons.share),
        //   onPressed: () {
        //     // Acción para compartir la publicación
        //     // Implementa la lógica para compartir la publicación aquí
        //   },
        // ),

        if (isOwner(context,
            postUserId)) // Verifica si el usuario es el propietario del post
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Muestra el menú emergente
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Actualizar'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPostPage(postId: postId),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Eliminar'),
                      onTap: () {
                        // Acción para eliminar el post
                        // Llamar a una función para eliminar el post aquí
                      },
                    ),
                  ),
                ],
              );
            },
          ),
       
      ],
    );
  }

  // Función para verificar si el usuario autenticado es el propietario del post
  bool isOwner(BuildContext context, String postUserId) {
    final userSession =
        Provider.of<UserSessionProvider>(context, listen: false).userSession;
    if (userSession != null) {
      return userSession.userId == postUserId;
    } else {
      return false;
    }
  }
}

bool isEdited(bool editado) {
  if (editado) {
    return true;
  } else {
    return false;
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: const Color.fromARGB(255, 106, 106, 106),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
                nick: post.nick,
                postUserId: post.userId,
  
                editado: post.editad,
                postId: post.id),
            const SizedBox(height: 10),
            Text(post.texto),
            const SizedBox(height: 10),
            if (post.urlImagen != "") Image.network(post.urlImagen!),
            const SizedBox(height: 10),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           //aqui poner la pagina para filtrar lugares
            //           builder: (context) => PostLugares(lugar: post.lugar)),
            //     );
            //   },
            //   child: Text(
            //     'Lugar: ${post.lugar}',
            //     style: const TextStyle(
            //       fontWeight: FontWeight.bold,
            //       decoration: TextDecoration.underline,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            Text(
              'Fecha de Creación: ${post.fechaCreacion}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
