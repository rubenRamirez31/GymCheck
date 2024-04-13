import 'package:flutter/material.dart';

class BottomNavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  BottomNavigationMenu({required this.selectedIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabTapped,
      backgroundColor: Colors.grey[800], // Cambiar color de fondo
      selectedItemColor: Colors.blue, // Cambiar color de íconos activos
      unselectedItemColor: Colors.grey, // Cambiar color de íconos inactivos
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Cambiar estilo de etiquetas activas
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Cambiar estilo de etiquetas inactivas
      items: [
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
