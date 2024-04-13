import 'package:flutter/material.dart';
import 'package:gym_check/src/models/body_data_model.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:provider/provider.dart';

class BodyDataPage extends StatelessWidget {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController grasaCorporalController = TextEditingController();
  final TextEditingController circunferenciaCinturaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Corporales'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: grasaCorporalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Grasa Corporal (%)'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: circunferenciaCinturaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Circunferencia de Cintura (cm)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _guardarDatos(context);
              },
              child: Text('Continuar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _agregarDespues(context);
              },
              child: Text('Agregar Después'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarDatos(BuildContext context) async {
    try {
      // Obtener los valores de los campos
      double peso = double.parse(pesoController.text);
      double grasaCorporal = double.parse(grasaCorporalController.text);
      double circunferenciaCintura = double.parse(circunferenciaCinturaController.text);

      // Obtener el ID de usuario y luego su nick
      String userId =
          Provider.of<UserSessionProvider>(context, listen: false)
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
      final response = await PhysicalDataService.addData(_nick, 'Registro-Diario', bodyData.toJson());

      // Mostrar mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Mensaje'),
          content: Text(response['message'] ?? 'Datos corporales guardados correctamente'),
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
      String userId =
          Provider.of<UserSessionProvider>(context, listen: false)
              .userSession!
              .userId;

      // Crear objeto User con el campo 'primerosPasos' igual a 4
      User user = User(primerosPasos: 4);

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

      // Redirigir a la página de body_data_page
      Navigator.pushNamed(context, '/nutritional_data');
    } catch (error) {
      print('Error al agregar datos corporales después: $error');
      // Manejar el error si es necesario
    }
  }
}
