import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/rutinas/view_workout_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/tracking_funtions.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/services/reminder_service.dart';
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

  Future<void> _deleteReminderAll() async {
    try {
      // Mostrar diálogo de confirmación antes de eliminar el recordatorio
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Eliminar recordatorios',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              '¿Estás seguro de que deseas eliminar este recordatorio? Toma en cuenta que esta acción también eliminará todos los recordatorios asociados. Esta acción no se puede deshacer.',
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancelar eliminación
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirmar eliminación
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
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
            backgroundColor: Colors.black,
            title: const Text(
              'Eliminar recordatorio',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              '¿Estás seguro de que deseas eliminar este recordatorio? solo se elimnara le recordatorio en esta fecha, los demas no se vrán afectados',
              style: TextStyle(
                fontSize: 16,
                //fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancelar eliminación
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirmar eliminación
                },
                child: const Text('Eliminar',
                    style: TextStyle(color: Colors.white)),
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
    final screenHeight = MediaQuery.of(context).size.height;
    // Verificar si _reminderData es nulo antes de acceder a sus propiedades
    final String fechaInicio = _reminderData != null
        ? TrackingFunctions.formatDateTime(_reminderData!['startTime'])
        : '';
    final String fechaFin = _reminderData != null
        ? TrackingFunctions.formatDateTime(_reminderData!['endTime'])
        : '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: _isLoading
          ? const Center(
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
                        const Text(
                          'Detalles del Recordatorio',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          //width: screenWidth - 30,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(_reminderData!['color']),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _reminderData!['title'] ?? 'Sin título',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    if (_reminderData!['workoutID'] != null)
                                      CustomButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewWorkoutPage(
                                                id: _reminderData!['workoutID'],
                                                buttons: true,
                                              ),
                                            ),
                                          );
                                        },
                                        text: 'Ir a Rutina',
                                        icon: Icons.sports_gymnastics,
                                      ),
                                    if (_reminderData!['dietID'] != null)
                                      CustomButton(
                                        onPressed: () {},
                                        text: 'Ir a Alimento',
                                        icon: Icons.restaurant_menu,
                                      ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Hora de Inicio: $fechaInicio',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Hora de Fin: $fechaFin',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //SizedBox(width: 5,),
                              Expanded(
                                child: Container(
                                  height: 120,
                                  width: 120,
                                   margin: EdgeInsets.symmetric(vertical: 5.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                   // height: 150,
                                    color: Colors.grey[200], // Color gris claro
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Bordes redondos
                                  ),
                                  constraints: const BoxConstraints(
                                    maxHeight: 150,
                                    maxWidth: 150,
                                    //maxWidth: (screenWidth - 30) * 0.4 -2.0, // Resta 2 pixeles de cada lado
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection:
                                        Axis.vertical, // Desplazamiento vertical
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Descripción: ${_reminderData!['description'] ?? 'Sin descripción'}',
                                              style: const TextStyle(
                                                color:
                                                    Colors.black, // Color del texto
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SingleChildScrollView(
                          //scrollDirection: Axis.horizontal,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                onPressed: () {
                                  _deleteReminderAll();
                                },
                                text: 'Eliminar Recordatorios',
                                icon: Icons.delete_sweep,
                              ),
                              _reminderData!['modelo'] == 'clon'
                                  ? CustomButton(
                                      onPressed: () {
                                        _deleteReminderDay();
                                      },
                                      text: 'Eliminar Recordatorio de este dia',
                                      icon: Icons.delete,
                                    )
                                  : const SizedBox(),
                              CustomButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddReminderPage(
                                                tipo: _reminderData!['tipo'],
                                                recordatorioId:
                                                    _reminderData!['id'],
                                              )),
                                    );
                                  },
                                  text: 'Modificar Recordatorio',
                                  icon: Icons.edit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('No se encontró el recordatorio'),
                ),
    );
  }
}
