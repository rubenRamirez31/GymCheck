import 'package:flutter/material.dart';

class WeeklyCalendar extends StatelessWidget {
  final Map<DateTime, List<Map<String, dynamic>>> tasks;

  WeeklyCalendar({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            DateTime now = DateTime.now();
            DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            DateTime date = startOfWeek.add(Duration(days: index));
            List<Map<String, dynamic>> dayTasks = tasks[date] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getWeekdayName(date.weekday),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${date.day}/${date.month}",
                  style: TextStyle(fontSize: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDayTasks(dayTasks),
                ),
                Divider(),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildDayTasks(List<Map<String, dynamic>> dayTasks) {
    List<Widget> taskWidgets = [];

    for (var task in dayTasks) {
      String taskName = task['name'];
      int hour = task['hour'];
      taskWidgets.add(Text("$hour-$taskName"));
    }

    return taskWidgets;
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Lunes";
      case 2:
        return "Martes";
      case 3:
        return "Miércoles";
      case 4:
        return "Jueves";
      case 5:
        return "Viernes";
      case 6:
        return "Sábado";
      case 7:
        return "Domingo";
      default:
        return "";
    }
  }
}
