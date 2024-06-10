import 'package:flutter/material.dart';

class DaysDropdown extends StatefulWidget {
  final ValueChanged<int?>
      onDaysNumberSelected; // Función de devolución de llamada para notificar sobre el número de días seleccionados
  final ValueChanged<List<int>?>
      onDaysSelected; // Función de devolución de llamada para notificar sobre los días seleccionados
  final int initialDaysNumber; // Número de días inicial
  final List<int> initialSelectedDays; // Días inicialmente seleccionados

  const DaysDropdown({
    Key? key,
    required this.onDaysNumberSelected,
    required this.onDaysSelected,
    this.initialDaysNumber = 10,
    this.initialSelectedDays = const [],
  }) : super(key: key);

  @override
  _DaysDropdownState createState() => _DaysDropdownState();
}

class _DaysDropdownState extends State<DaysDropdown> {
  late int _selectedDaysNumber; // Número de días seleccionados
  late List<int> _selectedRepeatDays; // Lista de días seleccionados

  List<Map<int, String>> _daysOptions = [
    {1: 'L'},
    {2: 'M'},
    {3: 'Mi'},
    {4: 'J'},
    {5: 'V'},
    {6: 'S'},
    {7: 'D'}
  ]; // Opciones de días

  @override
  void initState() {
    super.initState();
    _selectedDaysNumber = widget.initialDaysNumber;
    _selectedRepeatDays = List.from(widget.initialSelectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Text(
                _selectedDaysNumber.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
            PopupMenuButton<int>(
              offset: const Offset(0,
                  50), // Ajusta el offset para desplegar a la derecha
              itemBuilder: (BuildContext context) {
                return [10, 15, 30, 60].map((int daysNumber) {
                  return PopupMenuItem<int>(
                    value: daysNumber,
                    child: Text(
                      '$daysNumber días',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList();
              },
              onSelected: (int newDaysNumber) {
                setState(() {
                  _selectedDaysNumber = newDaysNumber;
                });
                widget.onDaysNumberSelected(
                    newDaysNumber); // Notifica al padre sobre el número de días seleccionados
              },
              child: const Row(
                children: [
                  Text('Selecciona los Días',
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
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _daysOptions.map((day) {
              int dayIndex = day.keys.first;
              String dayName = day.values.first;

              return Row(
                children: [
                  Column(
                    children: [
                      Checkbox(
                        value: _selectedRepeatDays.contains(dayIndex),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null && value) {
                              _selectedRepeatDays.add(dayIndex);
                            } else {
                              _selectedRepeatDays.remove(dayIndex);
                            }
                            widget.onDaysSelected(
                                _selectedRepeatDays); // Notifica al padre sobre los días seleccionados
                          });
                        },
                      ),
                      Text(dayName, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(width: 5),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
