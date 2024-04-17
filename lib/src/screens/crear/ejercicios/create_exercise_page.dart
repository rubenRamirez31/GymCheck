import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/values/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Creacion',
          style: TextStyle(color: AppColors.white, fontSize: 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.white,
            ), // Botón de búsqueda
            onPressed: () {
              // Acción al presionar el botón de búsqueda
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppColors.white,
            ), // Botón de notificaciones
            onPressed: () {
              // Acción al presionar el botón de notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.info,
                color: AppColors.white), // Botón de mensajes
            onPressed: () {
              setState(
                () {
                  print("Global " +
                      globalVariable.selectedMenuOptionTrackingPhysical
                          .toString());
                },
              );
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
    );
  }
}
