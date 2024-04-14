import 'package:flutter/material.dart';
import 'package:gym_check/src/components/app_text_form_field.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_strings.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:provider/provider.dart';

class GeneralDataPage extends StatefulWidget {
  const GeneralDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GeneralDataPageState createState() => _GeneralDataPageState();
}

class _GeneralDataPageState extends State<GeneralDataPage> {
  final _formKey = GlobalKey<FormState>();

  final txtPrimerNombre = TextEditingController();
  final txtSegundoNombre = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtGenero = TextEditingController();

  bool _buttonEnabled = false;

  void _updateButtonEnabled() {
    setState(() {
      _buttonEnabled = txtPrimerNombre.text.isNotEmpty &&
          txtApellidos.text.isNotEmpty &&
          txtGenero.text.isNotEmpty;
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
                'Datos Generales',
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text('Solo necesitamos saber un poco mas de ti',
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
                      labelText: 'Primer Nombre',
                      keyboardType: TextInputType.text,
                      controller: txtPrimerNombre),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Segundo Nombre',
                    keyboardType: TextInputType.text,
                    controller: txtSegundoNombre,
                    onChanged: (value) {
                      setState(() {
                        txtSegundoNombre.value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Apellidos',
                    keyboardType: TextInputType.text,
                    controller: txtApellidos,
                    onChanged: (value) {
                      setState(() {
                        txtApellidos.value;
                        _updateButtonEnabled();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Genero',
                    keyboardType: TextInputType.text,
                    controller: txtGenero,
                    onChanged: (value) {
                      setState(() {
                        txtGenero.value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed:
                        _buttonEnabled ? () => _primerosDatos(context) : null,
                    child: const Text('Continuar'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _primerosDatos(BuildContext context) async {
    try {
      User user = User(
          primerNombre: txtPrimerNombre.text,
          segundoNombre: txtSegundoNombre.text,
          apellidos: txtApellidos.text,
          genero: txtGenero.text,
          primerosPasos: 2,
          verificado: true);
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      await UserService.updateUser(userId, user);

      Map<String, dynamic> userData = await UserService.getUserData(userId);
      String _nick = userData['nick'];

      //crear la estructura de datos-fisicos

      await PhysicalDataService.createPhysicalData(_nick);

      Navigator.pushNamed(context, '/first_photo');
    } catch (error) {
      print('Error: $error');
      // Manejar el error si es necesario
    }
  }
}
