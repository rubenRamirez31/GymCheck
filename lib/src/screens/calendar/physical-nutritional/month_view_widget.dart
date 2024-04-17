import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/create_event_page.dart';

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
  List<CalendarEventData> eventsList = [];

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _addEvents(); // Agregar eventos al inicializar la página
  }

  // Método para agregar eventos a los días del 13/04/2024 al 16/04/2024
  void _addEvents() {
    // Lista de eventos
    eventsList = [
      CalendarEventData(
        title: "Evento 1",
        date: DateTime(2024, 4, 10),
        description: "Descripción del Evento 1",
        color: Colors.red,
        startTime: DateTime(2024, 4, 10, 13, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 10, 14, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Evento 1",
        date: DateTime(2024, 4, 11),
        description: "Descripción del Evento 1",
        color: Colors.red,
        startTime: DateTime(2024, 4, 11, 10, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 11, 12, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Evento 1",
        date: DateTime(2024, 4, 12),
        description: "Descripción del Evento 1",
        color: Colors.red,
        startTime: DateTime(2024, 4, 12, 10, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 12, 12, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Ir al Gym",
        date: DateTime(2024, 4, 13),
        description: "Toca pata",
        color: Color.fromARGB(255, 6, 48, 83),
        startTime: DateTime(2024, 4, 13, 13, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 13, 15, 30), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Ir al Gym",
        date: DateTime(2024, 4, 13),
        description: "Toca pata",
        color: Color.fromARGB(255, 73, 99, 120),
        startTime: DateTime(2024, 4, 13, 16, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 13, 17, 30), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Ir al Gym",
        date: DateTime(2024, 4, 13),
        description: "Toca pata",
        color: Color.fromARGB(255, 73, 99, 120),
        startTime: DateTime(2024, 4, 13, 16, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 13, 17, 30), // Hora de finalización del evento
      ),
      CalendarEventData(
        //type: "sdnsdn",
        title: "Ir al Gym",
        date: DateTime(2024, 4, 13),
        description: "Toca pata",
        color: Color.fromARGB(255, 73, 99, 120),
        startTime: DateTime(2024, 4, 13, 18, 0), // Hora de inicio del evento
        endTime:
            DateTime(2024, 4, 13, 19, 30), // Hora de finalización del evento
      ),
    ];

    // Agregar cada evento al controlador
    eventsList.forEach((event) {
      _eventController.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MonthView(
      key: widget.state,
      width: widget.width,
      controller: _eventController,
      onEventTap: (event, date) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailsPage(event: event)),
        );
        //print("object");
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
                  // Acción cuando se selecciona "Ver día"
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) =>
                            CreateEventPage(defaultStartDate: selectedDay)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Agregar Rutina'),
                onTap: () {
                  // Acción cuando se selecciona "Agregar Rutina"
                  Navigator.pop(context);
                },
              ),
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
