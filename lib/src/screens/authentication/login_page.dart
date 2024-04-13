// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_sesion_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función para manejar el inicio de sesión
  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Realizar inicio de sesión usando ApiService
    try {
      Map<String, dynamic>? userData =
          await UserService.loginUser(email, password);
      if (userData != null) {
        // Asigna el ID del usuario y el token obtenidos de la API
        final userId = userData['userId'];
        final token = userData['token'];
        final userSession = UserSession(userId: userId, token: token);
        Provider.of<UserSessionProvider>(context, listen: false)
            .setUserSession(userSession);

        print(userId);

        Map<String, dynamic> userData2 = await UserService.getUserData(userId);

        int _primeros_pasos = userData2['primeros_pasos'];
        print(_primeros_pasos);

        if (_primeros_pasos == 0) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/confirm_email');
        } else if (_primeros_pasos == 1) {
          Navigator.pushNamed(context, '/general_data');
        } else if (_primeros_pasos == 2) {
          Navigator.pushNamed(context, '/first_photo');
        } else if (_primeros_pasos == 3) {
          Navigator.pushNamed(context, '/body_data');
        } else if (_primeros_pasos == 4) {
          Navigator.pushNamed(context, '/nutritional_data');
        } else if (_primeros_pasos == 5) {
          Navigator.pushNamed(context, '/emotional_data');
        } else if (_primeros_pasos == 6) {
          Navigator.pushNamed(context, '/recomendar_premium');
        } else if (_primeros_pasos == 7) {
          Navigator.pushNamed(context, '/feed');
        }
      }
    } catch (error) {
      // Manejar el error en caso de fallo en el inicio de sesión
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Error al iniciar sesión. Por favor, revise su correo electrónico y contraseña.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true, // Ocultar texto de la contraseña
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Iniciar Sesión'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de registro al hacer clic en el botón
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
