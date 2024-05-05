// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:provider/provider.dart'; // Importa el servicio de usuario

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key});

  @override
  _ConfirmEmailPageState createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  final List<TextEditingController> _verificationCodeControllers =
      List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    // Limpiar los controladores de texto al eliminar el widget
    for (final controller in _verificationCodeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmEmail(BuildContext context) async {
    try {
      // Crear un mapa con los campos a actualizar
      Map<String, dynamic> userData = {
        'verificado': true,
        'primeros_pasos': 1,
      };

// Llamar al método updateUser con el mapa de datos y el contexto
      await updateUser(userData, context);
      // Mostrar un mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Éxito'),
          content: const Text('El correo se ha verificado exitosamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/general_data');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      // Mostrar mensaje de error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final globales = Provider.of<Globales>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Confirmar Correo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Correo electrónico: ${globales.correo}',
                style: const TextStyle(
                    color: Colors.white), // Texto en color blanco
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Mostrar un diálogo para confirmar la modificación
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Modificar Correo'),
                      content: const Text(
                          '¿Estás seguro de que deseas modificar tu correo electrónico?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Cerrar el diálogo
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Cerrar el diálogo
                            // Aquí puedes implementar la lógica para modificar el correo
                            print('Modificar correo');
                          },
                          child: const Text('Modificar'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Modificar Correo',
                    style: TextStyle(
                        color: Colors.white)), // Texto en color blanco,),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Aquí se pueden colocar los 4 TextField para el código de verificación
                  for (int i = 0; i < 4; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            0, 236, 236, 236), // Fondo blanco opaco
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: TextField(
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255,
                                255)), // Color del texto ingresado
                        controller: _verificationCodeControllers[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '', // Ocultar contador de longitud
                          border: InputBorder.none, // Sin borde
                        ),
                        onChanged: (value) {
                          // Aquí puedes manejar la lógica para el código de verificación
                          print('Código de verificación: $value');
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '¿No has recibido el código a tu correo?',
                style: TextStyle(color: Colors.white), // Texto en color blanco
              ),
              TextButton(
                onPressed: () {
                  // Aquí puedes implementar la lógica para reenviar el código
                  print('Reenviar código');
                },
                child: const Text(
                  'Reenviar',
                  style:
                      TextStyle(color: Colors.white), // Texto en color blanco
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validar si se han ingresado los 4 dígitos del código
                  if (_validateVerificationCode()) {
                    _confirmEmail(
                        context); // Llamar al método para confirmar el correo
                  } else {
                    // Mostrar un mensaje indicando que se deben ingresar los 4 dígitos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Por favor, ingresa los 4 dígitos del código de verificación')),
                    );
                  }
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para validar el código de verificación
  bool _validateVerificationCode() {
    // Iterar sobre los 4 TextField y verificar si su texto no es nulo y tiene una longitud de 1
    for (int i = 0; i < 4; i++) {
      String text = _verificationCodeControllers[i].text.trim();
      if (text.isEmpty || text.length != 1) {
        return false;
      }
    }
    return true;
  }
}
