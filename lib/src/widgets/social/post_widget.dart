import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/screens/social/profile_page.dart';
import 'package:gym_check/src/widgets/social/comment_box.dart';
import 'package:gym_check/src/widgets/social/favoritoitem.dart';
import 'package:gym_check/src/widgets/social/share_box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
                decoration: TextDecoration.underline),
          ),
        ),
        /* const Spacer(), */
        /*  if (isOwner(context,
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
          ), */
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

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
/*   late int commentCount = 0;

  @override
  void initState() {
    super.initState();
    // ignore: avoid_types_as_parameter_names
    getCommentCount(widget.post.id!).then((count) {
      setState(() {
        commentCount = count;
      });
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    PostHeader(
                        nick: widget.post.nick,
                        postUserId: widget.post.userId,
                        editado: widget.post.editad,
                        postId: widget.post.id!),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.post.texto!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widget.post.urlImagen != null &&
                                widget.post.urlImagen!.isNotEmpty
                            ? Stack(
                                children: [
                                  const SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  Center(
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: widget.post.urlImagen!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          widget.post.fechaCreacion != null
                              ? DateFormat('h:mm a d MMM yy')
                                  .format(widget.post.fechaCreacion!)
                              : 'Fecha no disponible',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FavoritoItem(postId: widget.post.id ?? ''),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.95,
                                      child: CommentBox(idpost: widget.post.id),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.mode_comment_outlined),
                            ),
/*                             if (commentCount > 0) const SizedBox(width: 0),
                            Visibility(
                              visible: commentCount > 0,
                              child: Text(
                                commentCount.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ), */
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return const FractionallySizedBox(
                                  heightFactor: 0.33,
                                  child: Share(),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.share_sharp),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> getCommentCount(String postId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Publicaciones")
        .doc(postId)
        .collection("comentarios")
        .get();
    return querySnapshot.size;
  }
}
