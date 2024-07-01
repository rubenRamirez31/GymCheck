import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/services/auth_service.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/values/app_theme.dart';

class EmailVerificationPage extends StatefulWidget {
  final User user;

  const EmailVerificationPage({Key? key, required this.user}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late User _user;
  late Timer _timer;
  final AuthService _authService = AuthService(); // Instancia de AuthService

  @override
  void initState() {
    super.initState();
    _user = widget.user;

    // Enviar correo de verificación
    _user.sendEmailVerification();

    // Comprobar periódicamente si el correo ha sido verificado
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _user.reload();
      if (_user.emailVerified) {
        timer.cancel();
        _onEmailVerified();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _onEmailVerified() async {
    SmartDialog.showLoading(msg: 'Verificando correo...');

    // Obtenemos el token de Firebase Cloud Messaging
    String? token = await FirebaseMessaging.instance.getToken();

    // Creamos el nuevo usuario
    Usuario newUser = Usuario(
      primerNombre: "",
      segundoNombre: "",
      apellidos: "",
      genero: "",
      nick: widget.user.displayName ?? "",
      correo: _user.email!,
      fotoPerfil: "",
      idAuth: _user.uid,
      primerosPasos: 1,
      fechaCreacion: DateTime.now(),
      verificado: true,
      tokenfcm: token,
    );

    // Subimos el usuario a Firestore
    int resU = await _authService.uploadUser(newUser);

    SmartDialog.dismiss();

    if (resU == 200) {
      // Si el usuario se creó exitosamente, redirigimos al login
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      SmartDialog.showToast('Correo verificado. Ahora puedes iniciar sesión.');
    } else {
      SmartDialog.showToast('Error al crear el usuario. Inténtalo de nuevo.');
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await _user.sendEmailVerification();
      SmartDialog.showToast('Correo de verificación reenviado.');
    } catch (e) {
      SmartDialog.showToast('Error al reenviar el correo de verificación.');
    }
  }

  Future<void> _changeEmail() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verificación de email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Por favor verifica tu correo electrónico",
              style: AppTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resendVerificationEmail,
              child: Text("Reenviar correo electrónico de verificación"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changeEmail,
              child: Text("Cambiar email"),
            ),
          ],
        ),
      ),
    );
  }
}
