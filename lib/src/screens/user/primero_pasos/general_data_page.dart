import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class GeneralDataPage extends StatefulWidget {
  @override
  _GeneralDataPageState createState() => _GeneralDataPageState();
}

class _GeneralDataPageState extends State<GeneralDataPage> {
  String _primerNombre = '';
  String _segundoNombre = '';
  String _apellidos = '';
  String _genero = '';
  bool _buttonEnabled = false;

  void _updateButtonEnabled() {
    setState(() {
      _buttonEnabled = _primerNombre.isNotEmpty &&
          _apellidos.isNotEmpty &&
          _genero.isNotEmpty;
    });
  }

  Future<void> _primerosDatos(BuildContext context) async {
    try {
      User user = User(
        primerNombre: _primerNombre,
        segundoNombre: _segundoNombre,
        apellidos: _apellidos,
        genero: _genero,
        primerosPasos: 2,
        verificado: true
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Generales'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Primer Nombre'),
              onChanged: (value) {
                setState(() {
                  _primerNombre = value;
                  _updateButtonEnabled();
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Segundo Nombre'),
              onChanged: (value) {
                setState(() {
                  _segundoNombre = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Apellidos'),
              onChanged: (value) {
                setState(() {
                  _apellidos = value;
                  _updateButtonEnabled();
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Género'),
              onChanged: (value) {
                setState(() {
                  _genero = value;
                  _updateButtonEnabled();
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buttonEnabled
                  ? () => _primerosDatos(context)
                  : null, // Deshabilitar el botón si no se han completado los campos
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
