import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart'; // Importa el servicio de usuario

class ConfirmEmailPage extends StatelessWidget {
  Future<void> _confirmEmail(BuildContext context) async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);

      int _primeros_pasos = userData['primeros_pasos'];
      print("holap id " + userId);
      print("holap primeos pasos " + _primeros_pasos.toString());

      // Crear un objeto User solo con los campos necesarios para actualizar
      User user = User(verificado: true, primerosPasos: 1);


      // Actualizar el usuario con los campos específicos
      await UserService.updateUser(userId, user);
      print("holap primeos pasos " + _primeros_pasos.toString());

      // Mostrar un mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('El correo se ha verificado exitosamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/general_data');
              },
              child: Text('OK'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Correo Electrónico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de editar correo
                //Navigator.pushNamed(context, '/edit_email_page');
              },
              child: Text('Modificar Correo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _confirmEmail(context), // Llamar al método _confirmEmail
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
