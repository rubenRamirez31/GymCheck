import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/enumerations.dart';
import 'package:gym_check/src/screens/calendar/extension.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/workout_caledar_widget.dart';
import 'package:gym_check/src/screens/calendar/web/web_home_page.dart';
import 'package:gym_check/src/screens/calendar/widgets/responsive_widget.dart';
import 'package:gym_check/src/screens/seguimiento/add_remider_page.dart';

class WorkOutCalendarDayPage extends StatefulWidget {
  const WorkOutCalendarDayPage({super.key});

  @override
  State<WorkOutCalendarDayPage> createState() => _WorkOutCalendarDayPageState();
}

class _WorkOutCalendarDayPageState extends State<WorkOutCalendarDayPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      webWidget: WebHomePage(
        selectedView: CalendarView.day,
      ),
      mobileWidget: Scaffold(


        body: WorkOutCalendarDayWidget(),
         //body: DayViewWidget(),
      ),
    );
  }


}