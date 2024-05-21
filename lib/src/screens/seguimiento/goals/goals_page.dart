import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_goal_page.dart';
import 'package:gym_check/src/screens/seguimiento/goals/view_diary_goals.dart';
import 'package:gym_check/src/screens/seguimiento/goals/view_main_goal.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: ViewMainGoalWidget()
    );
  }
}
