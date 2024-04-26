import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:provider/provider.dart';

class NutritionalDataPage extends StatefulWidget {
  const NutritionalDataPage({super.key});

  @override
  State<NutritionalDataPage> createState() => _NutritionalDataPageState();
}

class _NutritionalDataPageState extends State<NutritionalDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientBackground(
            children: [
              Text(
                'Datos \nnutricionales',
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
        title: const Text('Mensaje'),
        content: const Text('Colección de datos nutricionales no configurada.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _agregarDespues(BuildContext context) async {
    try {
     final globales = Provider.of<Globales>(context, listen: false);
      // Crear objeto User con el campo 'primerosPasos' igual a 5
      User user = User(primerosPasos: 5);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(globales.idAuth, user);

      // Mostrar mensaje de éxito
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mensaje'),
          content: const Text('Claro, después puedes llenar estos datos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/emotional_data');
    } catch (error) {
      print('Error al agregar datos nutricionales después: $error');
      // Manejar el error si es necesario
    }
  }
}
