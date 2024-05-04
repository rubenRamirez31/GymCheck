import 'package:flutter/material.dart';

class MenuButtonOption extends StatefulWidget {
  final List<String> options;
  final Function(int) onItemSelected;
  final List<Color> highlightColors; // Lista de colores de resaltado
  final int selectedMenuOptionGlobal;

  MenuButtonOption({
    required this.options,
    required this.onItemSelected,
    required this.highlightColors, // Recibe una lista de colores de resaltado
    required this.selectedMenuOptionGlobal,
  });

  @override
  _MenuButtonOptionState createState() => _MenuButtonOptionState();
}

class _MenuButtonOptionState extends State<MenuButtonOption> {
  late String selectedOption;
  late int _selectedMenuOption;

  @override
  void initState() {
    super.initState();
    _selectedMenuOption = widget.selectedMenuOptionGlobal;
    selectedOption = widget.options[_selectedMenuOption];
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

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOption = option;
                _selectedMenuOption = index;
                widget.onItemSelected(index);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  color: option == selectedOption
                      ? widget.highlightColors[index] // Usa el color de resaltado correspondiente
                      : const Color.fromARGB(255, 83, 83, 83),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: option == selectedOption ? Colors.black : Colors.white,
                    ),
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
