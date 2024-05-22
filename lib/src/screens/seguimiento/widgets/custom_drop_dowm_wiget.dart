import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  CustomDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: hint,
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            value: value,
            hint: Text(
              hint ?? '',
              style: TextStyle(color: Colors.white),
            ),
            dropdownColor: const Color.fromARGB(255, 55, 55, 55),
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ),
        IconButton(
          onPressed: () {
            onChanged(null);
          },
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
