import 'package:flutter/material.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/seguimiento/physical/physical_tracking_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:provider/provider.dart';

class AddDataPage extends StatefulWidget {
  final String tipoDeRegistro;

  AddDataPage({required this.tipoDeRegistro});

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  String? _selectedField;
  late TextEditingController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedField,
                  hint: const Text('Seleccionar tipo de dato'),
                  items: _getCamposPorRegistro().map((campo) {
                    return DropdownMenuItem<String>(
                      value: campo,
                      child: Text(campo),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedField = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (_selectedField != null) ...[
                  Text(_getDescription(_selectedField!)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: _selectedField),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el valor del campo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _guardarDatos(context);
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _guardarDatos(BuildContext context) async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      String _nick = userData['nick'];

      double valor = double.parse(_controller.text);
      String tipo = _getTipoPorCampo(_selectedField!);

      RegistroFisico bodyData = RegistroFisico(tipo: tipo, valor: valor);

      String coleccion = _getColeccion();

      final response = await PhysicalDataService.addData(
          _nick, coleccion, bodyData.toJson());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mensaje'),
          content: Text(response['message'] ?? 'Datos guardados correctamente'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PhysicalTrackingPage()),
      );
    } catch (error) {
      print('Error al guardar datos: $error');
    }
  }

  List<String> _getCamposPorRegistro() {
    switch (widget.tipoDeRegistro) {
      case 'corporales':
        return [
          'Peso (kg)',
          'Altura (cm)',
          'Grasa Corporal (%)',
          'Circunferencia de Cintura (cm)'
        ];
      case 'antropométricos':
        return [
          'Circunferencia de Cuello (cm)',
          'Circunferencia de Cadera (cm)',
          'Índice de Masa Corporal (IMC)'
        ];
      case 'Record':
        return [
          'Campo1',
          'Campo2',
          'Campo3'
        ]; // Añade los campos correspondientes
      default:
        return [];
    }
  }

  String _getDescription(String campo) {
    switch (campo) {
      case 'Peso (kg)':
        return 'Por favor, ingrese su peso actual en kilogramos.';
      case 'Altura (cm)':
        return 'Por favor, ingrese su altura actual en centímetros.';
      case 'Grasa Corporal (%)':
        return 'Por favor, ingrese su porcentaje de grasa corporal actual.';
      //
      case 'Circunferencia de Cintura (cm)':
        return 'Por favor, ingrese su circunferencia de cintura actual en centímetros.';
      case 'Circunferencia de Cuello (cm)':
        return 'Por favor, ingrese su circunferencia de cuello actual en centímetros.';
      case 'Circunferencia de Cadera (cm)':
        return 'Por favor, ingrese su circunferencia de cadera actual en centímetros.';
      case 'Índice de Masa Corporal (IMC)':
        return 'Por favor, ingrese su Índice de Masa Corporal (IMC) actual.';
      default:
        return '';
    }
  }

  String _getColeccion() {
    switch (widget.tipoDeRegistro) {
      case 'corporales':
        return 'Registro-Corporal';
      case 'antropométricos':
        return 'Registro-Antropometrico';
      case 'Record':
        return 'Otra-Coleccion'; // Añade la colección correspondiente
      default:
        return 'Registro-Diario';
    }
  }

  String _getTipoPorCampo(String campo) {
    switch (campo) {
      case 'Peso (kg)':
        return 'peso';
      case 'Altura (cm)':
        return 'altura';
      case 'Grasa Corporal (%)':
        return 'grasaCorporal';
      case 'Circunferencia de Cintura (cm)':
        return 'circunferenciaCintura';
      case 'Circunferencia de Cuello (cm)':
        return 'circunferenciaCuello';
      case 'Circunferencia de Cadera (cm)':
        return 'circunferenciaCadera';
      case 'Índice de Masa Corporal (IMC)':
        return 'imc';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
