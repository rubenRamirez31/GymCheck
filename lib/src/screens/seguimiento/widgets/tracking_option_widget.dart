import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/seguimiento/emotional/emotional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:provider/provider.dart';


class TrackingOptionWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const TrackingOptionWidget({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
     var globalVariable = Provider.of<GlobalVariablesProvider>(context); // Obtiene la instancia de GlobalVariable
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
                globalVariable.selectedSubPageTracking = 0;
               
              onItemSelected(0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhysicalTrackingPage()),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_run,
                  size: 30,
                  color: selectedIndex == 0 ? Colors.blue : Colors.black,
                ),
                SizedBox(height: 5),
                Text(
                  'Físico',
                  style: TextStyle(
                    color: selectedIndex == 0 ? Colors.blue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
               globalVariable.selectedSubPageTracking = 1;
                 print( 'Variable global de setpagetracking '+ globalVariable.selectedSubPageTracking.toString());
              onItemSelected(1);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmotionalTrackingPage()),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_emotions,
                  size: 30,
                  color: selectedIndex == 1 ? Colors.blue : Colors.black,
                ),
                SizedBox(height: 5),
                Text(
                  'Emocional',
                  style: TextStyle(
                    color: selectedIndex == 1 ? Colors.blue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
               globalVariable.selectedSubPageTracking = 2;
                 print( 'Variable global de setpagetracking '+ globalVariable.selectedSubPageTracking.toString());
              onItemSelected(2);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NutritionalTrackingPage()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 30,
                  color: selectedIndex == 2 ? Colors.blue : Colors.black,
                ),
                SizedBox(height: 5),
                Text(
                  'Nutricional',
                  style: TextStyle(
                    color: selectedIndex == 2 ? Colors.blue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
