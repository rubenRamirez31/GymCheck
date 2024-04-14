import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:provider/provider.dart';

class EmotionalDataPage extends StatefulWidget {
  const EmotionalDataPage({super.key});

  @override
  State<EmotionalDataPage> createState() => _EmotionalDataPageState();
}

class _EmotionalDataPageState extends State<EmotionalDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientBackground(
            children: [
              Text(
                'Datos \nEmocionales',
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text(
                  'Ingresa los siguientes datos nutricionales para una experiencia mas personalziada',
                  style: AppTheme.bodySmall),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _continuar(context);
                    },
                    child: const Text('Continuar'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _agregarDespues(context);
                    },
                    child: const Text('Agregar Después'),
                  ),
                ],
              ),
            ),
          )
        ],
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
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
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
