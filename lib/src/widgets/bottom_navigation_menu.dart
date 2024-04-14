import 'package:flutter/material.dart';
import 'package:gym_check/src/values/app_colors.dart';

class BottomNavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const BottomNavigationMenu(
      {super.key, required this.selectedIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabTapped,
      backgroundColor: AppColors.darkestBlue,
      selectedItemColor: AppColors.darkBlue, // Cambiar color de íconos activos
      unselectedItemColor: Colors.grey, // Cambiar color de íconos inactivos
      selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold), // Cambiar estilo de etiquetas activas
      unselectedLabelStyle: const TextStyle(
          fontWeight:
              FontWeight.normal), // Cambiar estilo de etiquetas inactivas
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Crear',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Seguimiento',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Mi Espacio',
        ),
      ],
    );
  }
}
