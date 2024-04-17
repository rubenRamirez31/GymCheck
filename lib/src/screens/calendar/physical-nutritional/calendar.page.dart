import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/create_event_page.dart';
import 'package:gym_check/src/screens/calendar/enumerations.dart';
import 'package:gym_check/src/screens/calendar/extension.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/calendar/web/web_home_page.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/day_view_widget.dart';
import 'package:gym_check/src/screens/calendar/widgets/responsive_widget.dart';

class CalendarPhysicalNutritionalPage extends StatefulWidget {
  //final DateTime date;

  const CalendarPhysicalNutritionalPage({Key? key}) : super(key: key);

  @override
  _CalendarPhysicalNutritionalPageState createState() =>
      _CalendarPhysicalNutritionalPageState();
}

class _CalendarPhysicalNutritionalPageState extends State<CalendarPhysicalNutritionalPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      webWidget: WebHomePage(
        selectedView: CalendarView.day,
      ),
      mobileWidget: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        body: MonthViewWidget(),
        // body: DayViewWidget(date: widget.date),
      ),
    );
  }
}
