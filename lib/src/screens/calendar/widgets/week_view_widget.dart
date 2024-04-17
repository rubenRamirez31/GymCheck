import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../event_details_page.dart';

class WeekViewWidget extends StatefulWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);

  @override
  _WeekViewWidgetState createState() => _WeekViewWidgetState();
}

class _WeekViewWidgetState extends State<WeekViewWidget> {
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
        endTime: DateTime(2024, 4, 10, 14, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Evento 2",
        date: DateTime(2024, 4, 11),
        description: "Descripción del Evento 1",
        color: Colors.red,
        startTime: DateTime(2024, 4, 11, 10, 0), // Hora de inicio del evento
        endTime: DateTime(2024, 4, 11, 12, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Evento 3",
        date: DateTime(2024, 4, 12),
        description: "Descripción del Evento 1",
        color: Colors.red,
        startTime: DateTime(2024, 4, 12, 10, 0), // Hora de inicio del evento
        endTime: DateTime(2024, 4, 12, 12, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Evento 3",
        date: DateTime(2024, 5, 12),
        description: "Descripción del Evento 1",
        color: const Color.fromARGB(255, 44, 37, 37),
        startTime: DateTime(2024, 5, 10, 10, 0), // Hora de inicio del evento
        endTime: DateTime(2024, 5, 10, 12, 0), // Hora de finalización del evento
      ),
    ];

    // Agregar cada evento al controlador
    eventsList.forEach((event) {
      _eventController.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WeekView(
        key: widget.state,
        width: widget.width,
        //startHour:8,
        showLiveTimeLineInAllDays: true,
        timeLineWidth: 65,
        liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
          color: Color.fromARGB(255, 11, 73, 149),
          showTime: true,
        ),
        controller: _eventController,
       onEventTap: (events, date) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsPage(
              event: events.first,
            ),
          ),
        );
      },
    );
  }
}
