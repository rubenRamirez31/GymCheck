import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/event_details_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';

import 'package:gym_check/src/services/reminder_service.dart';

class WorkOutCalendarDayWidget extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const WorkOutCalendarDayWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  State<WorkOutCalendarDayWidget> createState() =>
      _WorkOutCalendarDayWidgetState();
}

class _WorkOutCalendarDayWidgetState extends State<WorkOutCalendarDayWidget> {
  late EventController _eventController;
  List<Map<String, dynamic>> _routines = [];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DayView(
        
        key: widget.state,
        width: widget.width,
        startHour: 8,
        initialDay: DateTime.now(),
       // startDuration: Duration(),
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
       // onDateLongPress: (date) => AddReminderPage(selectedDate: date, tipo: "Rutina"),
        onDateLongPress: (date) => {

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
                  selectedDate: date,
                  tipo: "Rutina",
                ),
              );
            },
          )
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
      ),

    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: () {
    //       showModalBottomSheet(
    //         showDragHandle: true,
    //         shape: const RoundedRectangleBorder(
    //           borderRadius: BorderRadius.vertical(
    //             top: Radius.circular(15),
    //           ),
    //         ),
    //         context: context,
    //         isScrollControlled: true,
    //         builder: (context) {
    //           return FractionallySizedBox(
    //             heightFactor: 0.90,
    //             child: AddReminderPage(
    //               selectedDate: widget.state,
    //               tipo: "Rutina",
    //             ),
    //           );
    //         },
    //       );
    //     },
    //     icon: Icon(Icons.add),
    //     label: Text("Agregar Rutina"),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation
    //       .miniEndFloat, // Posición del botón flotante
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
