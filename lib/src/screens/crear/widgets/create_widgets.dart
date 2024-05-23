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
                textAlign: TextAlign.justify,
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

static Widget buildLabelGeneralListV2(List<String> ingredients, double fontSize) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 18, 18, 18),
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        title: Text(
          'Ingredientes:',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        children: [
          for (var ingredient in ingredients)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const Icon(Icons.fiber_manual_record, size: 12, color: Colors.white), // Icono de viñeta
                  const SizedBox(width: 5), // Espacio entre el icono y el texto
                  Expanded(
                    child: Text(
                      ingredient,
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
static Widget builPreparacion(String preparation) {
 return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        child: ExpansionTile(
          backgroundColor: Colors.transparent, // Fondo transparente para evitar duplicar el color del contenedor
          title: Text(
            'Preparación:',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                preparation,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.justify, // Alineación justificada del texto
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
