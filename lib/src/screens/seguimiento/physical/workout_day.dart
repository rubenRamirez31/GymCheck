import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/workout_caledar_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/day_workout_data_page.dart';

class WorkOutDataPage extends StatefulWidget {
  const WorkOutDataPage({Key? key}) : super(key: key);

  @override
  State<WorkOutDataPage> createState() => _WorkOutDataPageState();
}

class _WorkOutDataPageState extends State<WorkOutDataPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Mis Rutinas',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),

          // SingleChildScrollView(
          //   child: Container(
          //     height: 300, // Altura específica del área de desplazamiento
          //     // Ajusta los márgenes y el tamaño del contenedor según tus necesidades
          //     margin: const EdgeInsets.all(16.0),
          //     padding: const EdgeInsets.all(8.0),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       border: Border.all(color: Colors.grey),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     child: const WorkOutCalendarDayPage(),
          //   ),
          // ),

           _buildDayContainer("Lunes"),
           _buildDayContainer("Martes"),
           _buildDayContainer("Miércoles"),
           _buildDayContainer("Jueves"),
           _buildDayContainer("Viernes"),
           _buildDayContainer("Sábado"),
           _buildDayContainer("Domingo"),
        ],
      ),
    );
  }

  Widget _buildDayContainer(String day) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width - 30,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DayWorkOutDataPage(day: day)),
              );
            },
            child: Text('Ver'),
          ),
        ],
      ),
    );
  }

  void _showAddData(BuildContext context, String day) {
    showModalBottomSheet(
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
          heightFactor: 0.95,
          child: DayWorkOutDataPage(day: day),
        );
      },
    );
  }
}
