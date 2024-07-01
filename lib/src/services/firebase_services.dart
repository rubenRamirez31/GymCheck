import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/social/post_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<int> crearPost(Post p) async {
  CollectionReference coleccion = db.collection("Publicaciones");
  int codigo = 0;

  try {
    await coleccion.add(p.toJson());
    codigo = 200;
  } catch (e) {
    codigo = 500;
  }

  return codigo;
}

