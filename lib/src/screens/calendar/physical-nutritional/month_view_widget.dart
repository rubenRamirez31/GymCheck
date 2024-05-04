import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/create_event_page.dart';


import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';

import 'package:gym_check/src/services/reminder_service.dart';

import '../event_details_page.dart';
import 'select_day_view_page.dart';

class MonthViewWidget extends StatefulWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  _MonthViewWidgetState createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<MonthViewWidget> {
  late EventController _eventController;
  List<Map<String, dynamic>> _routines = [];
  Map<String, CalendarEventData> _eventMap =
      {}; // Mapa local para asociar IDs con eventos

  @override
  void initState() {
    super.initState();
    _eventController = EventController();

    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    try {
      final routines = await ReminderService.getAllReminders(context);
      setState(() {
        _routines = routines;
      });
      _addEvents(); // Agregar eventos después de cargar las rutinas
    } catch (error) {
      print('Error al cargar las rutinas: $error');
    }
  }

  void _addEvents() {
    // Iterar sobre las rutinas obtenidas y agregar eventos
    _routines.forEach((routine) {
      // Construir el objeto CalendarEventData a partir de la rutina
      CalendarEventData eventData = CalendarEventData(
        title: routine['title'],
        date: routine['startTime'],
        description: routine['description'],
        color: Color(routine['color']),
        startTime: routine['startTime'],
        endTime: routine['endTime'],
      );

      // Agregar el evento al controlador
      _eventController.add(eventData);

      // Asociar el ID del recordatorio con el evento en el mapa local
      _eventMap[routine['id']] = eventData;
      //print(routine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MonthView(
      key: widget.state,
      width: widget.width,
      cellAspectRatio: .5,

      // weekDayBuilder: (day) => 1,
      // startDay: WeekDays.monday,
      // pageTransitionDuration: Durations.long1,
      initialMonth: DateTime.now(),
      borderSize: 1,
      controller: _eventController,
      onEventTap: (event, date) {
        // Obtener el ID del evento a partir del mapa local
        String eventId = _eventMap.keys.firstWhere(
          (key) => _eventMap[key] == event,
          orElse: () => '',
        );
        if (eventId.isNotEmpty) {
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
                child: ViewReminder(
                  reminderId: eventId,
                ),
              );
            },
          );
        }
      },
      onCellTap: (events, date) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => SelectDayViewPage(selectedDate: date)),
        );
      },
      onDateLongPress: (date) => _showOptionsBottomSheet(context, date),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Ver día'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) =>
                            SelectDayViewPage(selectedDate: selectedDay)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add_alert),
                title: Text('Agregar Recordatorio'),
                onTap: () {
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
                        heightFactor: 0.90,
                        child: AddReminderPage(
                          selectedDate: selectedDay,
                          tipo: "Recordatorio",
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text('Agregar Rutina'),
                  onTap: () {
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
                          heightFactor: 0.90,
                          child: AddReminderPage(
                            selectedDate: selectedDay,
                            tipo: "Rutina",
                          ),
                        );
                      },
                    );
                  }),
              ListTile(
                leading: Icon(Icons.fastfood),
                title: Text('Agregar Comida'),
                onTap: () {
                  // Acción cuando se selecciona "Agregar Comida"
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
