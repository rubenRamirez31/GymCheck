import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/update_remider_page.dart';

import 'package:gym_check/src/services/reminder_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ViewReminder extends StatefulWidget {
  final String reminderId;

  const ViewReminder({Key? key, required this.reminderId}) : super(key: key);

  @override
  State<ViewReminder> createState() => _ViewReminderState();
}

class _ViewReminderState extends State<ViewReminder> {
  Map<String, dynamic>? _reminderData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(); // Inicializar la localización
    _loadReminderData();
  }

  Future<void> _loadReminderData() async {
    final reminderData =
        await ReminderService.getReminderById(context, widget.reminderId);
    setState(() {
      _reminderData = reminderData['reminder'];
      _isLoading = false;
    });
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(dateTimeString);
        String formattedDate =
            DateFormat('dd \'de\' MMMM \'a las\' hh:mm a', 'es')
                .format(dateTime);
        return formattedDate;
      } catch (error) {
        print('Error al formatear la fecha: $error');
      }
    }
    return 'Fecha no válida';
  }

  Future<void> _deleteReminder() async {
    try {
      // Mostrar diálogo de confirmación antes de eliminar el recordatorio
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Eliminar Recordatorio'),
            content: Text(
              '¿Estás seguro de que deseas eliminar este recordatorio? Toma en cuenta que esta acción también eliminará todos los recordatorios asociados. Esta acción no se puede deshacer.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancelar eliminación
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirmar eliminación
                },
                child: Text('Eliminar'),
              ),
            ],
          );
        },
      );

      // Si el usuario confirmó la eliminación, proceder con la eliminación del recordatorio
      if (confirmDelete == true) {
        // Actualizar el estado para mostrar la animación de eliminación
        setState(() {
          _isLoading = true;
        });

        // Eliminar el recordatorio
        final result = await ReminderService.deleteReminderIdRecordar(
            context, _reminderData!['idRecordar']);

        // Imprimir mensaje o manejar resultado como desees
        print(result);

        // Cerrar la página después de eliminar el recordatorio
        Navigator.of(context).pop();
      }
    } catch (error) {
      print('Error al eliminar recordatorio: $error');
    }
  }

  Future<void> _deleteReminderDay() async {
    try {
      // Mostrar diálogo de confirmación antes de eliminar el recordatorio
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Eliminar Recordatorio'),
            content: Text(
              '¿Estás seguro de que deseas eliminar este recordatorio? solo se elimnara le recordatorio en esta fecha, los demas no se vrán afectados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancelar eliminación
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirmar eliminación
                },
                child: Text('Eliminar'),
              ),
            ],
          );
        },
      );

      // Si el usuario confirmó la eliminación, proceder con la eliminación del recordatorio
      if (confirmDelete == true) {
        // Actualizar el estado para mostrar la animación de eliminación
        setState(() {
          _isLoading = true;
        });

        // Eliminar el recordatorio
        final result = await ReminderService.deleteReminderById(
            context, widget.reminderId);

        // Imprimir mensaje o manejar resultado como desees
        print(result);

        // Cerrar la página después de eliminar el recordatorio
        Navigator.of(context).pop();
      }
    } catch (error) {
      print('Error al eliminar recordatorio: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Verificar si _reminderData es nulo antes de acceder a sus propiedades
    final String fechaInicio = _reminderData != null
        ? formatDateTime(_reminderData!['startTime'])
        : '';
    final String fechaFin =
        _reminderData != null ? formatDateTime(_reminderData!['endTime']) : '';

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _reminderData != null
              ? SingleChildScrollView(
                  //scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Agregar espaciado alrededor del contenido
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Detalles del Recordatorio',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          width: screenWidth - 30,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(_reminderData!['color']),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _reminderData!['title'] ?? 'Sin título',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              if (_reminderData!['routineName'] != null)
                                ElevatedButton(
                                  onPressed: () {
                                    // Navegar a la página de la rutina
                                    // Implementa la navegación según tus necesidades
                                  },
                                  child: Text('Ir a Rutina'),
                                ),
                              Text(
                                'Descripción: ${_reminderData!['description'] ?? 'Sin descripción'}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Fecha de Inicio: $fechaInicio',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Fecha de Fin: $fechaFin',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _deleteReminder();
                                },
                                child: Text('Eliminar Recordatorios'),
                              ),
                              _reminderData!['modelo'] == 'clon'
                                  ? ElevatedButton(
                                      onPressed: () {
                                        _deleteReminderDay();
                                      },
                                      child: Text(
                                          'Eliminar Recordatorio de este dia'),
                                    )
                                  : const SizedBox(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  showModalBottomSheet(
                                    showDragHandle: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.60,
                                        child: UpdateReminderPage(
                                          reminderId: widget.reminderId,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('Modificar Recordatorio'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text('No se encontró el recordatorio'),
                ),
    );
  }
}
