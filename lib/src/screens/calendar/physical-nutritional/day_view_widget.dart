import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../event_details_page.dart';

class DayViewWidget extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  _DayViewWidgetState createState() => _DayViewWidgetState();
}

class _DayViewWidgetState extends State<DayViewWidget> {
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
       // color: Colors.red,
        startTime: DateTime(2024, 4, 12, 10, 0), // Hora de inicio del evento
        endTime: DateTime(2024, 4, 12, 12, 0), // Hora de finalización del evento
      ),
      CalendarEventData(
        title: "Ir al Gym",
        date: DateTime(2024, 4, 13),
        description: "Toca pata",
        color: Color.fromARGB(255, 6, 48, 83),
        startTime: DateTime(2024, 4, 13, 13, 0), // Hora de inicio del evento
        endTime: DateTime(2024, 4, 13, 15, 30), // Hora de finalización del evento
      ),
    ];

    // Agregar cada evento al controlador
    eventsList.forEach((event) {
      _eventController.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DayView(
      
      key: widget.state,
      width: widget.width,
      initialDay: DateTime.now(),
      startDuration: Duration(hours: 8),
      showHalfHours: true,
      heightPerMinute: 1,
      controller: _eventController,
      timeLineBuilder: _timeLineBuilder,
      hourIndicatorSettings: HourIndicatorSettings(
        color: Theme.of(context).dividerColor,
      ),
      onEventTap: (events, date) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsPage(
              event: events.first,
            ),
          ),
        );
      },
      halfHourIndicatorSettings: HourIndicatorSettings(
        color: Theme.of(context).dividerColor,
        lineStyle: LineStyle.dashed,
      ),
      verticalLineOffset: 0,
      timeLineWidth: 65,
      showLiveTimeLineInAllDays: true,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        showBullet: false,
        showTime: true,
        showTimeBackgroundView: true,
      ),
    );
  }

  Widget _timeLineBuilder(DateTime date) {
    if (date.minute != 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: -8,
            right: 8,
            child: Text(
              "${date.hour}:${date.minute}",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black.withAlpha(50),
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    final hour = ((date.hour - 1) % 12) + 1;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -8,
          right: 8,
          child: Text(
            "$hour ${date.hour ~/ 12 == 0 ? "am" : "pm"}",
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
