import 'package:flutter/material.dart';

// Clase principal que recibe una lista de opciones, una función para manejar la selección, 
// el índice de la opción seleccionada y una lista opcional de iconos.
class MenuButtonOption extends StatefulWidget {
  final List<String> options; // Lista de opciones de menú
  final Function(int) onItemSelected; // Función callback para manejar la selección de una opción
  final int selectedMenuOptionGlobal; // Índice de la opción seleccionada globalmente
  final List<IconData?>? icons; // Lista opcional de iconos para cada opción

  MenuButtonOption({
    required this.options, // Recibe la lista de opciones
    required this.onItemSelected, // Recibe la función callback
    required this.selectedMenuOptionGlobal, // Recibe el índice de la opción seleccionada globalmente
    this.icons, // Recibe la lista de iconos opcionales
  });

  @override
  _MenuButtonOptionState createState() => _MenuButtonOptionState();
}

// Estado asociado con MenuButtonOption
class _MenuButtonOptionState extends State<MenuButtonOption> {
  late String selectedOption; // Opción seleccionada actual
  late int _selectedMenuOption; // Índice de la opción seleccionada actual

  @override
  void initState() {
    super.initState();
    _selectedMenuOption = widget.selectedMenuOptionGlobal; // Inicializa con la opción seleccionada globalmente
    selectedOption = widget.options[_selectedMenuOption]; // Inicializa con la opción correspondiente al índice
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Permite desplazamiento horizontal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        // Mapea cada opción a un widget
        children: widget.options.asMap().entries.map((entry) {
          final int index = entry.key; // Índice de la opción
          final String option = entry.value; // Texto de la opción
          final IconData? icon = widget.icons != null && index < widget.icons!.length
              ? widget.icons![index]
              : null; // Icono correspondiente a la opción, si existe

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOption = option; // Actualiza la opción seleccionada
                _selectedMenuOption = index; // Actualiza el índice seleccionado
                widget.onItemSelected(index); // Llama a la función callback
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0), // Espaciado horizontal entre opciones
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10), // Padding interno del contenedor
                  color: option == selectedOption
                      ? Colors.white // Color de resaltado si la opción está seleccionada
                      : const Color.fromARGB(255, 83, 83, 83), // Color por defecto si no está seleccionada
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: option == selectedOption ? Colors.black : Colors.white, // Color del icono
                        ),
                        SizedBox(width: 8), // Espacio entre el icono y el texto
                      ],
                      Text(
                        option,
                        style: TextStyle(
                          color: option == selectedOption ? Colors.black : Colors.white, // Color del texto
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
