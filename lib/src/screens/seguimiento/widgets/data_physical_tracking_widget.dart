import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/physical/view_data_page.dart';

class DataPhysicalTracking extends StatelessWidget {
  final IconData icon;
  final String name;
  final String dataType;
  final String data;
  final String lastRecordDate;
  final String coleccion;
  final String tipo;
 final VoidCallback agregar;
  DataPhysicalTracking({
    required this.icon,
    required this.name,
    required this.dataType,
    required this.data,
    required this.lastRecordDate,
    required this.coleccion,
    required this.agregar,
    required this.tipo
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 40, 40), // Cambiar el color del contenedor a gris
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color.fromARGB(255, 255, 255, 255),), // Color del borde
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white, // Cambiar el color del icono a blanco
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 150, // Ancho máximo del texto
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Cambiar el color del texto a blanco
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.info, color: Colors.white), // Cambiar el color del icono a blanco
                    const SizedBox(width: 5),
                    Text(
                      dataType,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white, // Cambiar el color del texto a blanco
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      data.toString(),
                      style: const TextStyle(
                        color: Colors.white, // Cambiar el color del texto a blanco
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.white), // Cambiar el color del icono a blanco
                    const SizedBox(width: 5),
                    Text(
                      'Fecha: $lastRecordDate',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white, // Cambiar el color del texto a blanco
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: [
                    CustomButton(
                      onPressed: () {
                        _showViweData(context, name,tipo);
                        // Aquí podrías navegar a la pestaña correspondiente
                        // dependiendo del dataType
                        print('Se presionó el botón de Ver más para $name');
                      },
                      text: 'Ver más',
                      icon: Icons.table_rows_rounded,
                    ),
                    CustomButton(
                      onPressed: agregar,
                      text: 'Agregar',
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showViweData(BuildContext context, String data, String tipo) {
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
          child: ViewCorporalDataPage(
            data: data,
            coleccion: coleccion,
            tipo: tipo,
          ),
        );
      },
    );
  }
}
