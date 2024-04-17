import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/seguimiento/emotional/emotional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/physical_tracking_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/widgets/bottom_navigation_menu.dart';
import 'package:gym_check/src/widgets/crear/create_option_widget.dart';
import 'package:gym_check/src/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class CreateExercisePage extends StatefulWidget {
  const CreateExercisePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  int _selectedIndex = 0;
  int _selectedPage = 0;

  void _onTabTapped(int index) {
    var globalVariable =
        Provider.of<GlobalVariablesProvider>(context, listen: false);
    setState(() {
      _selectedPage = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/feed", (route) => false);
        break;
      case 1:
        break;
      case 2:
        if (globalVariable.selectedSubPageTracking == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PhysicalTrackingPage()),
          );
        } else if (globalVariable.selectedSubPageTracking == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmotionalTrackingPage()),
          );
        } else if (globalVariable.selectedSubPageTracking == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NutritionalTrackingPage()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Creacion',
        // profileImageUrl: _urlImagen,
        onProfilePressed: () {},
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Botón de búsqueda
            onPressed: () {
              // Acción al presionar el botón de búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications), // Botón de notificaciones
            onPressed: () {
              // Acción al presionar el botón de notificaciones
            },
          ),
          IconButton(
            icon: Icon(Icons.info), // Botón de mensajes
            onPressed: () {
              setState(() {
                print("Global " +
                    globalVariable.selectedMenuOptionTrackingPhysical
                        .toString());
              });
              // Acción al presionar el botón de mensajes
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreateOptionWidget(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                // Aquí puedes manejar la selección de la opción
                print('Opción seleccionada: $index');
              },
            ),

            // Aquí puedes agregar más contenido de la página CreateExercisePage según sea necesario
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationMenu(
            selectedIndex: 1,
            onTabTapped: _onTabTapped,
          ),
        ],
      ),
    );
  }
}
