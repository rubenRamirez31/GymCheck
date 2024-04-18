import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/calendar/app_colors.dart';

import 'package:gym_check/src/screens/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/seguimiento/physical/Antropometric_data_page.dart';

import 'package:gym_check/src/screens/seguimiento/physical/corporal_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_option_widget.dart';

import 'package:gym_check/src/services/user_service.dart';

import 'package:gym_check/src/widgets/menu_button_option_widget.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhysicalTrackingPage extends StatefulWidget {
  const PhysicalTrackingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhysicalTrackingPageState createState() => _PhysicalTrackingPageState();
}

class _PhysicalTrackingPageState extends State<PhysicalTrackingPage> {
  int _selectedPage = 0;
  int _selectedSubPage = 0;
  int _selectedMenuOption = 0;
  String _nick = '';
  String _urlImagen = '';

  List<String> options = [
    'Rutinas',
    'Datos corporales',
    'Datos antropométricos',
    'Metas',
    'Record personal',
    'Configuraciones'
  ]; // Lista de opciones

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSelectedMenuOption(); // Cargar el estado guardado de _selectedMenuOption
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 52, 78),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Container(
                height: 300, // Altura específica del área de desplazamiento
                // Ajusta los márgenes y el tamaño del contenedor según tus necesidades
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const MonthViewWidget(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Color.fromARGB(255, 29, 52, 78),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      highlightColor: Colors.green,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionTrackingPhysical =
                              _selectedMenuOption;
                        });
                        await prefs.setInt('selectedMenuOption', index);
                      },
                    ),
                    // Aquí puedes agregar más elementos MenuButtonOption según sea necesario
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _selectedMenuOption == 0
                ? Container(
                    color:
                        const Color.fromARGB(255, 0, 0, 255), // Contenedor azul
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : const SizedBox(), // Si _selectedMenuOption no es 2, no mostrar el contenedor
            _selectedMenuOption == 1
                ? const CorporalDataPage()
                : const SizedBox(), // Si _selectedMenuOption no es 0, no mostrar el contenedor
            _selectedMenuOption == 2
                ? const AntropometricDataPage()
                : const SizedBox(), // Si _selectedMenuOption no es 1, no mostrar el contenedor
            _selectedMenuOption == 3
                ? Container(
                    color:
                        const Color.fromARGB(255, 0, 0, 255), // Contenedor azul
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : const SizedBox(), // Si _selectedMenuOption no es 2, no mostrar el contenedor
            _selectedMenuOption == 4
                ? Container(
                    color: const Color.fromARGB(
                        255, 255, 255, 0), // Contenedor amarillo
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : const SizedBox(), // Si _selectedMenuOption no es 3, no mostrar el contenedor
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = prefs.getInt('selectedMenuOption') ?? 0;
    });
  }

  Future<void> _loadUserData() async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      setState(() {
        _nick = userData['nick'];
        _urlImagen = userData['urlImagen'];
      });
    } catch (error) {
      print('Error al cargar los datos del usuario: $error');
    }
  }
}
