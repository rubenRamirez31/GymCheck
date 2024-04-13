import 'package:flutter/material.dart';
import 'package:gym_check/src/models/body_data_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/seguimiento/physical/physical_tracking_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:provider/provider.dart';

class AddDataPage extends StatelessWidget {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController grasaCorporalController = TextEditingController();
  final TextEditingController circunferenciaCinturaController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar nuevo registro'),
        shadowColor: Colors.green,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Peso (kg)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el peso';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Altura (cm)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la altura';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: grasaCorporalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Grasa Corporal (%)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el porcentaje de grasa corporal';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: circunferenciaCinturaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Circunferencia de Cintura (cm)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la circunferencia de la cintura';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _guardarDatos(context);
                    }
                  },
                  child: Text('Agregar'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _guardarDatos(BuildContext context) async {
    try {
      double peso = double.parse(alturaController.text);
      double altura = double.parse(pesoController.text);
      double grasaCorporal = double.parse(grasaCorporalController.text);
      double circunferenciaCintura = double.parse(circunferenciaCinturaController.text);

      String userId = Provider.of<UserSessionProvider>(context, listen: false).userSession!.userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      String _nick = userData['nick'];

      BodyData bodyData = BodyData(
        peso: peso,
        altura: altura,
        grasaCorporal: grasaCorporal,
        circunferenciaCintura: circunferenciaCintura,
      );

      final response = await PhysicalDataService.addData(_nick, 'Registro-Diario', bodyData.toJson());

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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhysicalTrackingPage()),
      );
    } catch (error) {
      print('Error al guardar datos corporales: $error');
    }
  }
}
