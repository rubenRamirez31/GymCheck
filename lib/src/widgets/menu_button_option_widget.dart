import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:provider/provider.dart';

// Este archivo define un widget llamado MenuButtonOption que se utiliza para mostrar una serie de botones de opciones horizontales.

class MenuButtonOption extends StatefulWidget {
  final List<String> options; // Lista de opciones
  final Function(int) onItemSelected; // Función de devolución de llamada cuando se selecciona una opción
  final Color highlightColor; // Color de resaltado cuando se selecciona una opción

  MenuButtonOption({
    required this.options, // Requiere la lista de opciones
    required this.onItemSelected, // Requiere la función de devolución de llamada
    required this.highlightColor, // Requiere el color de resaltado
  });

  @override
  _MenuButtonOptionState createState() => _MenuButtonOptionState(); // Crea el estado del widget
}

class _MenuButtonOptionState extends State<MenuButtonOption> {
  late String selectedOption; // Opción seleccionada
  late int _selectedMenuOption; // Opción de menú seleccionada

  @override
  void initState() {
    super.initState();
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context,
        listen: false);
    _selectedMenuOption = globalVariable.selectedMenuOptionTrackingPhysical; // Obtiene la opción de menú seleccionada
    selectedOption = widget.options[_selectedMenuOption]; // Establece la opción seleccionada
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario del widget
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Permitir desplazamiento horizontal
      child: Row(
        children: widget.options.asMap().entries.map((entry) {
          final int index = entry.key; // Índice de la opción
          final String option = entry.value; // Valor de la opción

          return GestureDetector(
            onTap: () {
              // Maneja el evento de selección de una opción
              setState(() {
                selectedOption = option; // Actualiza la opción seleccionada
                _selectedMenuOption = index; // Actualiza la opción de menú seleccionada
                widget.onItemSelected(index); // Llama a la función de devolución de llamada con el índice seleccionado
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Bordes redondeados del botón
                child: Container(
                  padding: EdgeInsets.all(10), // Espaciado interno del botón
                  color: option == selectedOption
                      ? widget.highlightColor // Color de resaltado si está seleccionado
                      : Colors.grey[300], // Color de fondo normal
                  child: Text(option), // Texto de la opción del botón
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
