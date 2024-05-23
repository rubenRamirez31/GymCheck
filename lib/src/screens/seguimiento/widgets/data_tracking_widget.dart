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
      padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 10),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 5),
                  Text(
                    dataType,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(width: 10),
                  Text(data.toString()),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.calendar_month), // Nuevo icono para la fecha
                  const SizedBox(width: 5),
                  Text(
                    'Fecha: $lastRecordDate',
                    style: const TextStyle(fontStyle: FontStyle.italic),
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
                child: const Text('Ver más'),
              ),
            ),
          ),
        ],
      ),
    );
  }

    void _showViweData(BuildContext context, String data) {
    showModalBottomSheet(
       backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
