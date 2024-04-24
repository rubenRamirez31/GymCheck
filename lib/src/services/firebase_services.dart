import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

Future<String> login(String correo, String pwd) async {
  try {
    UserCredential credenciales =
        await auth.signInWithEmailAndPassword(email: correo, password: pwd);
    return "200";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
      return "Usuario y/o Contraseña incorrecta";
    } else {
      return e.code;
    }
  }
}
