import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/create_event_page.dart';
import 'package:gym_check/src/screens/calendar/enumerations.dart';
import 'package:gym_check/src/screens/calendar/extension.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/select_day_view_widget.dart';
import 'package:gym_check/src/screens/calendar/web/web_home_page.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/day_view_widget.dart';
import 'package:gym_check/src/screens/calendar/widgets/responsive_widget.dart';

class SelectDayViewPage extends StatefulWidget {
  final DateTime selectedDate;

  const SelectDayViewPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _SelectDayViewPageState createState() => _SelectDayViewPageState();
}

class _SelectDayViewPageState extends State<SelectDayViewPage> {
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
        body: SelectDayViewWidget(selectedDate: widget.selectedDate),
         //body: DayViewWidget(),
      ),
    );
  }
}