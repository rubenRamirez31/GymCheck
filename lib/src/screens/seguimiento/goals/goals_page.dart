import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_goal_page.dart';
import 'package:gym_check/src/screens/seguimiento/goals/view_main_goal.dart';


class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ViewMainGoalWidget(), // Parte superior con la vista de la meta principal
          ),
          Container(
            color: Colors.blue, // Color de fondo azul
            padding: EdgeInsets.all(20), // Espaciado interno
            child: Text(
              'Metas Diarias', // Texto provisional
              style: TextStyle(
                color: Colors.white, // Color de texto blanco
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
