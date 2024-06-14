import 'package:flutter/material.dart';

class TrackingWidgets {
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
       crossAxisAlignment: CrossAxisAlignment.start, // Align vertically to top
        children: [
          Flexible(
            flex: 1, // Allocate equal space for label
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
         // const SizedBox(width: 10.0), // Spacer
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right, // Align value to right
            ),
          ),
        ],
      ),
    ),
  );
}

static Widget buildLabelDetailsRowOnly(
  String label,
  MainAxisAlignment alineacion, {
  MainAxisSize ajustar = MainAxisSize.max,
  Color backColor = const Color.fromARGB(255, 18, 18, 18),
  Color textColor = Colors.white,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0),
    child: Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: alineacion,
        mainAxisSize: ajustar,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: textColor),
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
          title: const Text(
            '¿Con qué equipo se puede realizar?',
            style: TextStyle(fontSize: 16, color: Colors.white),
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
   static void showInfo(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            content,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
