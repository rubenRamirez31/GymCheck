import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/settings/macros_settings.dart';

class SettingsPage extends StatefulWidget {
  final String clase;

  SettingsPage({required this.clase});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text('Configuraciones'),
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
       // centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
         iconTheme: const IconThemeData(
          color:
              Colors.white, // Cambia el color del icono de retroceso a blanco
        ),
        //automaticallyImplyLeading: false, // Elimina el icono de volver atrás
      ),
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
      // body: Container(
      //   color: Color.fromARGB(255, 18, 18, 18),
      //   child: widget.clase == "Macros" ? MacroSettingsWidget() : Container(),
      // ),
    );
  }
}
