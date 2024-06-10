import 'package:flutter/material.dart';

class MenuButtonOption extends StatefulWidget {
  final List<String> options;
  final Function(int) onItemSelected;
  final List<Color>? highlightColors; // Lista de colores de resaltado
  final int selectedMenuOptionGlobal;
  final List<IconData?>? icons; // Lista de iconos opcionales

  MenuButtonOption({
    required this.options,
    required this.onItemSelected,
     this.highlightColors, // Recibe una lista de colores de resaltado
    required this.selectedMenuOptionGlobal,
    this.icons, // Lista de iconos opcionales
  });

  @override
  _MenuButtonOptionState createState() => _MenuButtonOptionState();
}

class _MenuButtonOptionState extends State<MenuButtonOption> {
  late int _selectedMenuOption;
    List<Color> highlightColors2 = [
    Colors.white, // Color de resaltado para 'Fisico'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Nutricional'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMenuOption = widget.selectedMenuOptionGlobal;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.options.asMap().entries.map((entry) {
          final int index = entry.key;
          final String option = entry.value;
          final IconData? icon = widget.icons != null && index < widget.icons!.length
              ? widget.icons![index]
              : null;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMenuOption = index;
                widget.onItemSelected(_selectedMenuOption);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  color: _selectedMenuOption == index
                      ? Colors.white // Usa el color de resaltado correspondiente
                      : const Color.fromARGB(255, 83, 83, 83),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: _selectedMenuOption == index ? Colors.black : Colors.white,
                        ),
                        SizedBox(width: 8), // Espacio entre el icono y el texto
                      ],
                      Text(
                        option,
                        style: TextStyle(
                          color: _selectedMenuOption == index ? Colors.black : Colors.white,
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
