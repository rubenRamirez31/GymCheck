import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/physical-nutritional/select_day_view_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_primary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_secundary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';
import 'package:gym_check/src/services/reminder_service.dart';


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
      final routines = await ReminderService.getAllRemindersClon(context);
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
    return DayView(
      key: widget.state,
      width: widget.width,
      initialDay: widget.selectedDate,
      startDuration: const Duration(hours: 8),
      showHalfHours: true,
      heightPerMinute: 2,
      controller: _eventController,
      timeLineBuilder: _timeLineBuilder,
      hourIndicatorSettings: HourIndicatorSettings(
        color: Theme.of(context).dividerColor,
      ),
      onEventTap: (event, date) {
        // Obtener el ID del evento a partir del mapa local
        String eventId = _eventMap.keys.firstWhere(
          (key) => _eventMap[key] == event,
          orElse: () => 'id',
        );
        if (eventId.isNotEmpty) {
          showModalBottomSheet(
            //   barrierColor: Colors.black,
            backgroundColor: Colors.black,
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
        }else{
          print("No hay id");
        }
      },
      onDateLongPress: (date) {
        _showOptionsBottomSheet(context, date);
      },
      halfHourIndicatorSettings: HourIndicatorSettings(
        color: Theme.of(context).dividerColor,
        lineStyle: LineStyle.dashed,
      ),
      verticalLineOffset: 0,
      timeLineWidth: 65,
      showLiveTimeLineInAllDays: true,
      liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
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

  void _showOptionsBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              ListTile(
                leading: const Icon(Icons.add_alert, color: Colors.white),
                title: const Text('Agregar Recordatorio',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPrimaryReminderPage(
                              tipo: "Recordatorio",
                            )),
                  );
                },
              ),
              ListTile(
                  leading: const Icon(Icons.fitness_center, color: Colors.white),
                  title: const Text('Agregar Rutina',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddSecondaryReminderPage(
                                tipo: "Rutina",
                              )),
                    );
                  }),
              ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.white),
                title: const Text('Agregar Comida',
                    style: TextStyle(color: Colors.white)),
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
