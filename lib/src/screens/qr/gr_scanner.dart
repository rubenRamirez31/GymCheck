import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/profile/other_profile_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _handleResult(scanData.code ?? "");
    });
  }

  void _handleResult(String result) {
    List<String> parts = result.split(':');
    String tipoDocumento = parts[0];
    String claveDocumento = parts[1];

    // Aquí puedes implementar la lógica para redirigir según tipoDocumento
    if (tipoDocumento == 'usuario') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtherProfilePage(userNick: claveDocumento),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
