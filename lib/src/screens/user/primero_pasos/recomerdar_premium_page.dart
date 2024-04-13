import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class RecomendarPlanPremiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendar Plan Premium'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _suscribirseDespues(context);
              },
              child: Text('Suscribirse Después'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _suscribirseAhora(context);
              },
              child: Text('Suscribirse Ahora'),
            ),
          ],
        ),
      ),
    );
  }

  void _suscribirseDespues(BuildContext context) async {
    try {
      // Obtener el ID de usuario
      String userId =
          Provider.of<UserSessionProvider>(context, listen: false)
              .userSession!
              .userId;

      // Crear objeto User con el campo 'primerosPasos' igual a 7
      User user = User(primerosPasos: 7);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(userId, user);

      // Navegar a la página Feed
      Navigator.pushNamed(context, '/feed');
    } catch (error) {
      print('Error al suscribirse después: $error');
      // Manejar el error si es necesario
    }
  }

  void _suscribirseAhora(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mensaje'),
        content: Text('Configuración de suscripciones aún no terminada.'),
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
}
