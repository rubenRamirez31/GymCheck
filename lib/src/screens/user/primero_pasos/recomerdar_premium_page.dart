// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/services/firebase_services.dart';
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
    final globales = context.watch<Globales>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
                  'Con la subscripcion premium tienes acceso a más herramientas las cuales te ayudarán a mejorar tu siguiemiento: físico, emocional y nutricional.',
                  style: AppTheme.bodySmall),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      late User? currentUser;

                      FirebaseAuth auth = FirebaseAuth.instance;
                      currentUser = auth.currentUser;

                      String currentUserIdAuth = currentUser!.uid;

                      // ignore: use_build_context_synchronously
                      await Provider.of<Globales>(context, listen: false)
                          .cargarDatosUsuario(currentUserIdAuth);

                      SmartDialog.showToast(
                          "Sesion iniciada como ${globales.nick}");

                      _suscribirseDespues(context);
                    },
                    child: const Text('Suscribirse Después'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      SmartDialog.showLoading(msg: "Cargando");

                      late User? currentUser;

                      FirebaseAuth auth = FirebaseAuth.instance;
                      currentUser = auth.currentUser;

                      String currentUserIdAuth = currentUser!.uid;

                      // ignore: use_build_context_synchronously
                      await Provider.of<Globales>(context, listen: false)
                          .cargarDatosUsuario(currentUserIdAuth);

                      SmartDialog.showToast(
                          "Sesion iniciada como ${globales.nick}");

                      _suscribirseAhora(context);

                      SmartDialog.dismiss();
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
      Map<String, dynamic> userData = {
        'primeros_pasos': 7,
      };

      await updateUser(userData, context);

      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/principal", (route) => false);
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
