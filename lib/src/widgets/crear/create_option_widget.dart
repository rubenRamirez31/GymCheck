import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/crear/dietas/create_diets_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/create_exercise_page.dart';
// Importa la página de "Mi espacio"
import 'package:provider/provider.dart';

class CreateOptionWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CreateOptionWidget({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    var globalVariable =
        Provider.of<GlobalVariablesProvider>(context); // Obtiene la instancia de GlobalVariable
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOption(
            selectedIndex: selectedIndex,
            index: 0,
            icon: Icons.fitness_center,
            text: 'Ejercicios',
            onPressed: () {
              globalVariable.selectedSubPageCreate = 0;
              onItemSelected(0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateExercisePage()),
              );
            },
          ),
          _buildOption(
            selectedIndex: selectedIndex,
            index: 1,
            icon: Icons.restaurant_menu,
            text: 'Dietas',
            onPressed: () {
              globalVariable.selectedSubPageCreate = 1;
              onItemSelected(1);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateDietPage()),
              );
            },
          ),
          _buildOption(
            selectedIndex: selectedIndex,
            index: 2,
            icon: Icons.savings_rounded, // Cambia el icono según sea necesario
            text: 'Mio', // Cambia el texto según sea necesario
            onPressed: () {
              globalVariable.selectedSubPageCreate = 2;
              onItemSelected(2);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateDietPage()), // Enlaza con la página de "Mi espacio"
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required int selectedIndex,
    required int index,
    required IconData icon,
    required String text,
    required Function onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed as void Function(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: selectedIndex == index ? Colors.blue : Colors.black,
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: selectedIndex == index ? Colors.blue : Colors.black,
            ),
          ),
          if (selectedIndex == index) // Agrega la línea resaltada solo si la opción está seleccionada
            Container(
              height: 2,
              width: 60, // Ancho de la línea resaltada
              color: Colors.blue, // Color de la línea resaltada
            ),
        ],
      ),
    );
  }
}
