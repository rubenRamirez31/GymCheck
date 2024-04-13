import 'package:flutter/material.dart';

class DataTracking extends StatelessWidget {
  final IconData icon;
  final String name;
  final String dataType;
  final String data;
  final String lastRecordDate;

  DataTracking({
    required this.icon,
    required this.name,
    required this.dataType,
    required this.data,
    required this.lastRecordDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 5),
                  Text(
                    dataType,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(width: 10),
                  Text(data.toString()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.calendar_month), // Nuevo icono para la fecha
                  SizedBox(width: 5),
                  Text(
                    'Fecha: $lastRecordDate',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí podrías navegar a la pestaña correspondiente
                  // dependiendo del dataType
                  print('Se presionó el botón de Ver más para $name');
                },
                child: Text('Ver más'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
