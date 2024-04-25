import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/physical/view_corporal_data_page.dart';

class DataTracking extends StatelessWidget {
  final IconData icon;
  final String name;
  final String dataType;
  final String data;
  final String lastRecordDate;
  final String coleccion;

  DataTracking({
    required this.icon,
    required this.name,
    required this.dataType,
    required this.data,
    required this.lastRecordDate,
    required this.coleccion
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
                  _showViweData(context, name);
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

    void _showViweData(BuildContext context, String data) {
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
          child: ViewCorporalDataPage(data: data, coleccion: coleccion,),
        );
      },
    );
  }
}
