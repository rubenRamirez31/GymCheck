import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/enumerations.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/extension.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/physical-nutritional/select_day_view_widget.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/web/web_home_page.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/widgets/responsive_widget.dart';

class SelectDayViewPage extends StatefulWidget {
  final DateTime selectedDate;

  const SelectDayViewPage({Key? key, required this.selectedDate})
      : super(key: key);

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
        appBar: AppBar(
          backgroundColor: const Color(0xff0C1C2E),
          title: const Text(
            'Vista diaria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: SelectDayViewWidget(selectedDate: widget.selectedDate),
        //body: DayViewWidget(),
      ),
    );
  }
}
