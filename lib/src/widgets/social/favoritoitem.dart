import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class FavoritoItem extends StatefulWidget {
  final String postId;
  const FavoritoItem({super.key, required this.postId});

  @override
  State<FavoritoItem> createState() => _FavoritoItemState();
}

class _FavoritoItemState extends State<FavoritoItem> {
  bool favorite = false;
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
}
