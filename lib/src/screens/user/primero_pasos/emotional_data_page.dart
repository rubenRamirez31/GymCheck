import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class EmotionalDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Emocionales'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _continuar(context);
              },
              child: Text('Continuar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _agregarDespues(context);
              },
              child: Text('Agregar Después'),
            ),
          ],
        ),
      ),
    );
  }

  void _continuar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mensaje'),
        content: Text('Colección de datos emocionales no configurada.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _agregarDespues(BuildContext context) async {
    try {
      // Obtener el ID de usuario
      String userId =
          Provider.of<UserSessionProvider>(context, listen: false)
              .userSession!
              .userId;

      // Crear objeto User con el campo 'primerosPasos' igual a 6
      User user = User(primerosPasos: 6);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(userId, user);

      // Mostrar mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Mensaje'),
          content: Text('Claro, después puedes llenar estos datos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      Navigator.pushNamed(context, '/recomendar_premium');
    } catch (error) {
      print('Error al agregar datos emocionales después: $error');
      // Manejar el error si es necesario
    }
  }
}
