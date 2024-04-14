import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:provider/provider.dart';

class RecomendarPlanPremiumPage extends StatefulWidget {
  const RecomendarPlanPremiumPage({super.key});

  @override
  State<RecomendarPlanPremiumPage> createState() =>
      _RecomendarPlanPremiumPageState();
}

class _RecomendarPlanPremiumPageState extends State<RecomendarPlanPremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientBackground(
            children: [
              Text(
                'Suscribete a Nuestro \nPlan Premiun',
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text(
                  'Con la subscripcion premium tinenes acceso a más herramientas las cuales te ayudarán a mejorar tu siguiemiento: físico, emocional y nutricional.',
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
                      _suscribirseDespues(context);
                    },
                    child: const Text('Suscribirse Después'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _suscribirseAhora(context);
                    },
                    child: const Text('Suscribirse Ahora'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _suscribirseDespues(BuildContext context) async {
    try {
      // Obtener el ID de usuario
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;

      // Crear objeto User con el campo 'primerosPasos' igual a 7
      User user = User(primerosPasos: 7);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(userId, user);

      // Navegar a la página Feed
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil("/feed", (route) => false);
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
