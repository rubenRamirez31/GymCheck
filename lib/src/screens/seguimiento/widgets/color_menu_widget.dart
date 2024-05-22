import 'package:flutter/material.dart';

class ColorDropdown extends StatefulWidget {
  final ValueChanged<Color?>
      onColorSelected; // Función de devolución de llamada para notificar sobre el color seleccionado

  const ColorDropdown({Key? key, required this.onColorSelected})
      : super(key: key);

  @override
  _ColorDropdownState createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  Color _selectedColor = Colors.red; // Color inicial seleccionado
  List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ]; // Lista de colores

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //shape: BoxShape.circle,
            color: _selectedColor,
          ),
        ),
        SizedBox(width: 10),
        PopupMenuButton<Color>(
          offset: Offset(0, 50), // Ajusta el offset para desplegar a la derecha
          itemBuilder: (BuildContext context) {
            return _colors.map((Color color) {
              return PopupMenuItem<Color>(
                value: color,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              );
            }).toList();
          },
          onSelected: (Color newColor) {
            setState(() {
              _selectedColor = newColor;
            });
            widget.onColorSelected(
                newColor); // Notifica al padre sobre el color seleccionado
          },
          child: Row(
            children: [
              Text('Selecciona un color',
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
          color: Colors.grey[800], // Establece el color de fondo del menú
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
