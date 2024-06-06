import 'package:flutter/material.dart';

class DecimalSlider extends StatelessWidget {
  final int selectedDecimal;
  final int maxValue; // Nuevo parámetro para el valor máximo del slider
  final ValueChanged<int> onChanged;

  const DecimalSlider({
    Key? key,
    required this.selectedDecimal,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (selectedDecimal > 0) {
              onChanged(selectedDecimal - 1);
            }
          },
        ),
        Expanded(
          flex: 3,
          child: Slider(
            activeColor: const Color.fromARGB(255, 25, 57, 94),
            value: selectedDecimal.toDouble(),
            min: 0,
            max: maxValue.toDouble(), // Usar el valor máximo proporcionado
            divisions: maxValue,
            label: selectedDecimal.toString(),
            onChanged: (value) {
              onChanged(value.toInt());
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (selectedDecimal < maxValue) {
              onChanged(selectedDecimal + 1);
            }
          },
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(
                selectedDecimal.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
