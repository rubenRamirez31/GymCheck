// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:gym_check/src/components/app_text_form_field.dart';

import 'package:gym_check/src/screens/user/primero_pasos/edad_page.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';


import 'package:gym_check/src/values/app_theme.dart';


class GeneralDataPage extends StatefulWidget {
  const GeneralDataPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GeneralDataPageState createState() => _GeneralDataPageState();
}

class _GeneralDataPageState extends State<GeneralDataPage> {

  final txtPrimerNombre = TextEditingController();
  final txtSegundoNombre = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtGenero = TextEditingController();
  String dropdownValue = 'Masculino';
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GradientBackground(
            children: [
              Text(
                "Primeros pasos",
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text("Llena estos datos", style: AppTheme.bodySmall),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppTextFormField(
                      textInputAction: TextInputAction.next,
                      labelText: 'Primer Nombre',
                      keyboardType: TextInputType.text,
                      controller: txtPrimerNombre,
                      textStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(255, 18, 18, 18),
                      // onChanged: (_) => _updateButtonEnabled(),
                    ),
                    const SizedBox(height: 20),
                    AppTextFormField(
                      textInputAction: TextInputAction.next,
                      labelText: 'Segundo Nombre (Opcional)',
                      keyboardType: TextInputType.text,
                      controller: txtSegundoNombre,
                      textStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(255, 18, 18, 18),
                      //onChanged: (_) => _updateButtonEnabled(),
                    ),
                    const SizedBox(height: 20),
                    AppTextFormField(
                      textInputAction: TextInputAction.next,
                      labelText: 'Apellidos',
                      keyboardType: TextInputType.text,
                      controller: txtApellidos,
                      textStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(255, 18, 18, 18),
                      //onChanged: (_) => _updateButtonEnabled(),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Género',
                        labelStyle: const TextStyle(color: Colors.white),
                        fillColor: const Color.fromARGB(255, 18, 18, 18),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white), // Color del borde
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: dropdownValue,
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                      items: <String>['Femenino', 'Masculino', 'Binario']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: Colors
                                    .white), // Establece el color del texto en blanco
                          ),
                        );
                      }).toList(),
                    ),
                    if (_isDataIncomplete())
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Por favor, completa todos los campos obligatorios.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_isDataIncomplete()) {
            _primerosDatos(context);
           
          }
        },
        backgroundColor: const Color(0xff0C1C2E),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  bool _isDataIncomplete() {
    return txtPrimerNombre.text.isEmpty ||
        txtApellidos.text.isEmpty ||
        dropdownValue.isEmpty;
  }

  Future<void> _primerosDatos(BuildContext context) async {
    try {
      Map<String, dynamic> userData = {
        'primeros_pasos': 2,
        'primer_nombre': txtPrimerNombre.text,
        'segundo_nombre': txtSegundoNombre.text.isNotEmpty ? txtSegundoNombre.text : null,
        'apellidos': txtApellidos.text,
        'genero': dropdownValue,
      };

       await updateUser(userData, context);

     Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EdadPage()));
      // await UserService.updateUser(globales.idAuth, user);

      //Navigator.pushNamed(context, '/first_photo');
    } catch (error) {
      print('Error: $error');
    }
  }
}
