import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/social/comentario.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/social/comentario.dart';
import 'package:provider/provider.dart';

class CommentBox extends StatefulWidget {
  final String? idpost;
  const CommentBox({super.key, this.idpost});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final double _maxHeight =
      4 * 24.0; // Máximo 4 líneas, cada línea tiene 24 de altura.

  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
    final Stream<QuerySnapshot> comentariosStream = FirebaseFirestore.instance
        .collection("Publicaciones")
        .doc(widget.idpost)
        .collection("comentarios")
        .orderBy("fecha", descending: true)
        .snapshots();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              key: PageStorageKey<String>('comentarios_${widget.idpost}'),
              stream: comentariosStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Algo salio mal intentalo de nuevo"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((e) {
                    Comentario c = Comentario.getFirebaseId(
                      e.id,
                      e.data() as Map<String, dynamic>,
                    );
                    return ComentarioCard(comentario: c);
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox.shrink()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          color: const Color.fromARGB(255, 250, 241, 246),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: _maxHeight),
                    child: TextFormField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: "Comentar como ${globales.nick}",
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                IconButton(
                  color: AppColors.primaryColor,
                  onPressed: () async {
                    SmartDialog.showLoading(msg: 'Comentando');
                    if (_controller.text.isEmpty) {
                      SmartDialog.showToast("No puede estar vacio");
                      SmartDialog.dismiss();
                    } else {
                      await FirebaseFirestore.instance
                          .collection("Publicaciones")
                          .doc(widget.idpost)
                          .collection("comentarios")
                          .add({
                        "userIdAuth": globales.idAuth,
                        "correo": globales.correo,
                        "fecha": DateTime.now(),
                        "comentario": _controller.text
                      });
                      SmartDialog.dismiss();
                      SmartDialog.showToast('Publicado');
                      _controller.clear();
                      // ignore: use_build_context_synchronously
                      FocusScope.of(context).unfocus();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
