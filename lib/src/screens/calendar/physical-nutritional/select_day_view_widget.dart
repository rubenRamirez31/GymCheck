import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/services/reminder_service.dart';

import '../event_details_page.dart';

class SelectDayViewWidget extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;
  final DateTime selectedDate;

  const SelectDayViewWidget({
    Key? key,
    this.state,
    this.width,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _SelectDayViewWidgetState createState() => _SelectDayViewWidgetState();
}

class _SelectDayViewWidgetState extends State<SelectDayViewWidget> {
  late EventController _eventController;
  List<Map<String, dynamic>> _remider = [];

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
        _remider = routines;
      });
      _addEvents(); // Agregar eventos después de cargar las rutinas
    } catch (error) {
      print('Error al cargar las rutinas: $error');
    }
  }

  void _addEvents() {
    
    _remider.forEach((routine) {
      CalendarEventData eventData = CalendarEventData(
        title: routine['title'],
        date: routine['startTime'],
        description: routine['description'],
        color: Color(routine['color']),
        startTime: routine['startTime'],
        endTime: routine['endTime'],
      );
    
      _eventController.add(eventData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DayView(
      key: widget.state,
      width: widget.width,
      initialDay: widget.selectedDate,
      startDuration: Duration(hours: 8),
      showHalfHours: true,
      heightPerMinute: 2,
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
      onDateLongPress: (date) => print(date),
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
