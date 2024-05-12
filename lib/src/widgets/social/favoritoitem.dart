import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FavoritoItem extends StatefulWidget {
  final String? userId;
  final String postId;
  const FavoritoItem({super.key, required this.postId, this.userId});

  @override
  State<FavoritoItem> createState() => _FavoritoItemState();
}

class _FavoritoItemState extends State<FavoritoItem> {
  bool favorite = false;
  String? userToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserToken(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
    return FutureBuilder(
      future: esFavorito(widget.postId, globales.idAuth),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool favorite = snapshot.data ?? false;
          return IconButton(
            onPressed: () async {
              if (favorite) {
                QueryDocumentSnapshot<Map<String, dynamic>> buscarFavorito;
                await FirebaseFirestore.instance
                    .collection("Publicaciones")
                    .doc(widget.postId)
                    .collection("favoritos")
                    .where('userIdAuth', isEqualTo: globales.idAuth)
                    .get()
                    .then((value) {
                  buscarFavorito = value.docs.first;
                  if (buscarFavorito.exists) {
                    FirebaseFirestore.instance
                        .collection("Publicaciones")
                        .doc(widget.postId)
                        .collection("favoritos")
                        .doc(buscarFavorito.id)
                        .delete();
                    favorite = false;
                  }
                });
              } else {
                await FirebaseFirestore.instance
                    .collection("Publicaciones")
                    .doc(widget.postId)
                    .collection("favoritos")
                    .doc()
                    .set({
                  "correo": globales.correo,
                  "fecha": DateTime.now().toString(),
                  "userIdAuth": globales.idAuth
                });
                favorite = true;
                //enviar notificacion push de like
                http.post(
                  Uri.parse('https://notificationpushapi-xncc.onrender.com/'),
                  headers: {"Content-type": "application/json"},
                  body: jsonEncode(
                    {
                      "token": [userToken],
                      "data": {
                        "title": globales.nick,
                        "body": "le gustó tu publicación"
                      }
                    },
                  ),
                );
              }

              setState(() {});
            },
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<bool> esFavorito(String postId, String userid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Publicaciones")
        .doc(postId)
        .collection("favoritos")
        .get();

    bool existe = false;
    if (snapshot.size > 0) {
      existe =
          snapshot.docs.any((element) => element.data().containsValue(userid));
    }
    return existe;
  }

  Future<void> getUserToken(String? userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where("userIdAuth", isEqualTo: userId)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        // Verificar si el objeto es un mapa antes de verificar si contiene la clave
        if (userData is Map && userData.containsKey('tokenfcm')) {
          if (mounted) {
            // Verificar si el widget está montado antes de llamar a setState
            setState(() {
              userToken = userData['tokenfcm'];
            });
          }
        }
      }
    } catch (e) {
      print('Error al obter el token del usuario: $e');
    }
  }
}
