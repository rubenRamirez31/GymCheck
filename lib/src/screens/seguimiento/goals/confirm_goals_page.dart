import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmGoal extends StatelessWidget {
  final Map<String, Map<String, dynamic>> selectedGoals;
  final Map<String, dynamic> macros;
  final String goalType;
  final DateTime startDate;
  final DateTime endDate;

  ConfirmGoal({
    required this.selectedGoals,
    required this.macros,
    required this.goalType,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Goal'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Goal Type: $goalType',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Selected Goals:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildSelectedGoalsList(),
            SizedBox(height: 16),
            Text(
              'Macros:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Proteins: ${macros['proteins']}'),
            Text('Carbs: ${macros['carbs']}'),
            Text('Fats: ${macros['fats']}'),
            SizedBox(height: 16),
            Text(
              'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGoalsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedGoals.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Selected: ${entry.value['selected']}'),
            Text('Reminder Time: ${entry.value['reminderTime']}'),
            SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}
