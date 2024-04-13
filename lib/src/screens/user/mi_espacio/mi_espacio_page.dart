import 'package:flutter/material.dart';

class MiEspacioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Espacio'),
      ),
      body: Center(
        child: Text(
          'Bienvenido a Mi Espacio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
