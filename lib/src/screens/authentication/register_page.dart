import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/services/user_service.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nickController = TextEditingController();

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String nick = _nickController.text.trim();

    if (email.isEmpty || password.isEmpty || nick.isEmpty) {
      // Validar que los campos no estén vacíos
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor ingrese todos los campos.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Crear un objeto User con los datos del usuario
    User user = User(email: email, password: password, nick: nick);

    // Registrar usuario usando ApiService
    String? errorMessage = await UserService.createUser(user);

    if (errorMessage == null) {
      // Registro exitoso, navegar a la página de inicio de sesión
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/');
    } else {
      // Mostrar mensaje de error en SmartDialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Algo Salio mal...:('),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
        title: const Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            TextField(
              controller: _nickController,
              decoration: const InputDecoration(labelText: 'Nick'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _register, // Llamar al método _register para registrar al usuario
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
