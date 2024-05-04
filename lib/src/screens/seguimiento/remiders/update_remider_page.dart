import 'package:flutter/material.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:intl/intl.dart';

class UpdateReminderPage extends StatefulWidget {
  final String reminderId;

  const UpdateReminderPage({Key? key, required this.reminderId})
      : super(key: key);

  @override
  _UpdateReminderPageState createState() => _UpdateReminderPageState();
}

class _UpdateReminderPageState extends State<UpdateReminderPage> {
  String _title = '';
  String _description = '';
  Color _selectedColor = Colors.blue;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];


  Map<String, dynamic>? _reminderData;
 

  @override
  void initState() {
    super.initState();
   
    _loadReminderData();
  }

  Future<void> _loadReminderData() async {
    final reminderData =
        await ReminderService.getReminderById(context, widget.reminderId);
    setState(() {
      _reminderData = reminderData['reminder'];
    
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Título',
                hintText: 'Ingrese un nuevo título',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ingrese una nueva descripción',
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButton<Color>(
              value: _selectedColor,
              onChanged: (Color? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedColor = newValue;
                  });
                }
              },
              items: _colors.map<DropdownMenuItem<Color>>((Color color) {
                return DropdownMenuItem<Color>(
                  value: color,
                  child: Container(
                    width: 30,
                    height: 30,
                    color: color,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showUpdateConfirmationDialog();
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUpdateConfirmationDialog() async {
    try {
      bool confirmUpdate = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Actualizar Recordatorio'),
            content: Text('¿Estás seguro de que deseas actualizar este recordatorio?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancelar actualización
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirmar actualización
                },
                child: Text('Actualizar'),
              ),
            ],
          );
        },
      );

      // Si el usuario confirmó la actualización, proceder con la actualización del recordatorio
      if (confirmUpdate == true) {
        await _updateReminder();
      }
    } catch (error) {
      print('Error al mostrar diálogo de confirmación de actualización: $error');
    }
  }

  Future<void> _updateReminder() async {
    try {
      // Crear un mapa con los campos actualizados
      Map<String, dynamic> updatedFields = {
        'title': _title,
        'description': _description,
        'color': _selectedColor.value,
      };

      // Llamar al servicio para actualizar el recordatorio en el servidor
      final result =
          await ReminderService.updateReminderIdrecordar(context, _reminderData!['idRecordar'], updatedFields);

      // Imprimir mensaje o manejar resultado como desees
      print(result);

      // Cerrar la página después de actualizar el recordatorio
      Navigator.of(context).pop();
    } catch (error) {
      print('Error al actualizar recordatorio: $error');
    }
  }
}
