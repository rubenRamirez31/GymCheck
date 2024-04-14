import 'package:flutter/material.dart';
import 'package:gym_check/src/components/app_text_form_field.dart';
import 'package:gym_check/src/models/body_data_model.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:provider/provider.dart';

class BodyDataPage extends StatefulWidget {
  const BodyDataPage({super.key});

  @override
  State<BodyDataPage> createState() => _BodyDataPageState();
}

class _BodyDataPageState extends State<BodyDataPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController pesoController = TextEditingController();
  final TextEditingController grasaCorporalController = TextEditingController();
  final TextEditingController circunferenciaCinturaController =
      TextEditingController();

  bool _buttonEnabled = false;

  void _updateButtonEnabled() {
    setState(() {
      _buttonEnabled = pesoController.text.isNotEmpty &&
          grasaCorporalController.text.isNotEmpty &&
          circunferenciaCinturaController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientBackground(
            children: [
              Text(
                'Datos Corporales',
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text(
                  'Para una experiencia mas personalizada necesiamos los siguientes datos',
                  style: AppTheme.bodySmall),
            ],
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Peso (kg)',
                    keyboardType: TextInputType.number,
                    controller: pesoController,
                    onChanged: (value) {
                      setState(() {
                        pesoController.value;
                        _updateButtonEnabled();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Grasa Corporal (%)',
                    keyboardType: TextInputType.number,
                    controller: grasaCorporalController,
                    onChanged: (value) {
                      setState(() {
                        grasaCorporalController.value;
                        _updateButtonEnabled();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: ' Circunferencia de Cintura (cm)',
                    keyboardType: TextInputType.number,
                    controller: circunferenciaCinturaController,
                    onChanged: (value) {
                      setState(() {
                        circunferenciaCinturaController.value;
                        _updateButtonEnabled();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed:
                        _buttonEnabled ? () => _guardarDatos(context) : null,
                    child: const Text('Continuar'),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => _agregarDespues(context),
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

  void _guardarDatos(BuildContext context) async {
    try {
      // Obtener los valores de los campos
      double peso = double.parse(pesoController.text);
      double grasaCorporal = double.parse(grasaCorporalController.text);
      double circunferenciaCintura =
          double.parse(circunferenciaCinturaController.text);

      // Obtener el ID de usuario y luego su nick
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      String _nick = userData['nick'];

      // Crear objeto BodyData con los datos ingresados
      BodyData bodyData = BodyData(
        peso: peso,
        grasaCorporal: grasaCorporal,
        circunferenciaCintura: circunferenciaCintura,
      );

      // Llamar al método addData del servicio physical-data-service
      final response = await PhysicalDataService.addData(
          _nick, 'Registro-Diario', bodyData.toJson());

      // Mostrar mensaje de éxito
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Mensaje'),
          content: Text(response['message'] ??
              'Datos corporales guardados correctamente'),
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

      // Redirigir a la página de body_data_page
      Navigator.pushNamed(context, '/nutritional_data');
    } catch (error) {
      print('Error al guardar datos corporales: $error');
      // Manejar el error si es necesario
    }
  }

  void _agregarDespues(BuildContext context) async {
    try {
      // Obtener el ID de usuario
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;

      // Crear objeto User con el campo 'primerosPasos' igual a 4
      User user = User(primerosPasos: 4);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(userId, user);

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
              child: Text('OK'),
            ),
          ],
        ),
      );

      // Redirigir a la página de body_data_page
      Navigator.pushNamed(context, '/nutritional_data');
    } catch (error) {
      print('Error al agregar datos corporales después: $error');
      // Manejar el error si es necesario
    }
  }
}
