import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';

 class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login(String correo, String pwd) async {
    try {
      UserCredential credenciales = await _auth.signInWithEmailAndPassword(
          email: correo, password: pwd);
      return "200";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        return "Usuario y/o Contraseña incorrecta";
      } else {
        return e.code ?? "Error desconocido al iniciar sesión";
      }
    }
  }

  Future<String?> crearUsuario(String correo, String pwd) async {
    try {
      UserCredential credenciales =
          await _auth.createUserWithEmailAndPassword(email: correo, password: pwd);

      return credenciales.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Este correo ya está en uso";
      } else {
        return e.code ?? "Error desconocido al crear usuario";
      }
    }
  }

  Future<bool> checkNick(String nick) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection("Usuarios")
          .where("nick", isEqualTo: nick)
          .get();
      return userSnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<int> uploadUser(Usuario u) async {
    CollectionReference coleccion = _firestore.collection("Usuarios");
    int codigo = 0;

    try {
      await coleccion.add(u.toJson());
      codigo = 200;
    } catch (e) {
      codigo = 500;
    }

    return codigo;
  }
}
