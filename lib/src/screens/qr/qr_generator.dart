import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatefulWidget {
  final String tipoDocumento;
  final String claveDocumento;

  const QRGenerator({
    required this.tipoDocumento,
    required this.claveDocumento,
  });

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {
    String data = '${widget.tipoDocumento}:${widget.claveDocumento}';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              widget.claveDocumento,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo del contenedor
                borderRadius: BorderRadius.circular(
                    20), // Radio de los bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color de la sombra
                    spreadRadius: 5, // Extensión de la sombra
                    blurRadius: 7, // Desenfoque de la sombra
                    offset: Offset(0, 3), // Desplazamiento de la sombra
                  ),
                ],
              ),
              padding: EdgeInsets.all(10), // Espaciado interno del contenedor

              child: QrImageView(
                backgroundColor: Colors.white,
                data: data,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
                embeddedImage: AssetImage('assets/icon/icon.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
