import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a la página de creación',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Esta página es para crear ejercicios, dietas y más',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              child: Text('Crear Ejercicio'),
            ),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              child: Text('Crear Dieta'),
            ),
            // Agregar más botones según sea necesario
          ],
        ),
      ),
    );
  }
}
