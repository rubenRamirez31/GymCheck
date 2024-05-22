import 'package:flutter/material.dart';

class CreateWidgets {
 
  static Widget buildLabelDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLabelDetailsRowOnly(String label, MainAxisAlignment alineacion, {MainAxisSize ajustar = MainAxisSize.max} ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: alineacion,
         mainAxisSize: ajustar,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

 static Widget buildLabelGeneral(String label, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLabelGeneralList(List<String> equipment, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        child: ExpansionTile(
          backgroundColor: Colors
              .transparent, // Fondo transparente para evitar duplicar el color del contenedor
          title: Text(
            '¿Con qué equipo se puede realizar?',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          children: [
            for (var item in equipment)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  item,
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
