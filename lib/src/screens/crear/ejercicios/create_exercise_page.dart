import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/crear/create_option_widget.dart';
import 'package:gym_check/src/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class CreateExercisePage extends StatefulWidget {
  final Function? openDrawer;
  const CreateExercisePage({super.key, this.openDrawer});

  @override
  // ignore: library_private_types_in_public_api
  State<CreateExercisePage> createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  TextEditingController textController = TextEditingController();
  int _selectedIndex = 0;
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable
    final globales = context.watch<Globales>();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            widget.openDrawer!();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(globales.fotoPerfil),
            ),
          ),
        ),
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Creacion',
          style: TextStyle(color: AppColors.white, fontSize: 25),
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
            AnimSearchBar(
              width: 400,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
              onSubmitted: (String) {},
            ),

            // Aquí puedes agregar más contenido de la página CreateExercisePage según sea necesario
          ],
        ),
      ),
    );
  }
}
