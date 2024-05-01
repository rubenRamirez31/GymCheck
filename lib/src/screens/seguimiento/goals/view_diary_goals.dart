import 'package:flutter/material.dart';

class ViewDailyGoalWidget extends StatefulWidget {
  const ViewDailyGoalWidget({Key? key}) : super(key: key);

  @override
  State<ViewDailyGoalWidget> createState() => _ViewDailyGoalWidgetState();
}

class _ViewDailyGoalWidgetState extends State<ViewDailyGoalWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Aquí puedes agregar tus widgets
              Text(
                'Contenido de la vista de la meta diaria',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón
                },
                child: Text('Botón'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
