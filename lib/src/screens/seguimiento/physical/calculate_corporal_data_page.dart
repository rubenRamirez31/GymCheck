import 'package:flutter/material.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_drop_dowm_wiget.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:provider/provider.dart';

class CalculateCorporalDataPage extends StatefulWidget {
  const CalculateCorporalDataPage({Key? key}) : super(key: key);

  @override
  _CalculateCorporalDataPageState createState() =>
      _CalculateCorporalDataPageState();
}

class _CalculateCorporalDataPageState extends State<CalculateCorporalDataPage> {
  String? _selectedCalculation;
  double? _calculatedValue;
  String? _calculationInfo;

  final List<String> _calculations = [
    'Índice de masa corporal (IMC)',
    'Ritmo metabólico basal (RMB)',
    'Porcentaje de cambio de peso',
    'Relación cintura-cadera'
  ];

  final String _coleccion = 'Registro-Corporal';
  double _peso = 0;
  double _altura = 0;
  double _cintura = 0;
  double _cadera = 0;
  double _pesoAnterior = 0;
    bool _calculados = false;


  @override
  void initState() {
    super.initState();
      bool _calculados = false;

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      Map<String, dynamic> pesoData = await PhysicalDataService.getLatestPhysicalData(context, _coleccion, 'peso');
      Map<String, dynamic> alturaData = await PhysicalDataService.getLatestPhysicalData(context, _coleccion, 'altura');
      Map<String, dynamic> cinturaData = await PhysicalDataService.getLatestPhysicalData(context, _coleccion, 'circunferenciaCintura');
      Map<String, dynamic> caderaData = await PhysicalDataService.getLatestPhysicalData(context, _coleccion, 'circunferenciaCadera');
      Map<String, dynamic> pesoAnteriorData = await PhysicalDataService.getLatestPhysicalData(context, _coleccion, 'peso');

      setState(() {
        _peso = pesoData['peso'] ?? 0;
        _altura = alturaData['altura'] ?? 0;
        _cintura = cinturaData['circunferenciaCintura'] ?? 0;
        _cadera = caderaData['circunferenciaCadera'] ?? 0;
        _pesoAnterior = pesoAnteriorData['peso'] ?? 0;
      });
    } catch (error) {
      print('Error loading user physical data: $error');
    }
  }

  void _calculateData() {
    final globales = Provider.of<Globales>(context, listen: false);
    double? result;
    String? info;
    bool datosCompletos = true;
    String mensajeError = '';

    switch (_selectedCalculation) {
      case 'Índice de masa corporal (IMC)':
        if (_peso <= 0 || _altura <= 0) {
          datosCompletos = false;
          mensajeError = 'Por favor ingresa el peso y la altura para calcular el IMC.';
        } else {
          double alturaM = _altura / 100;
          result = _peso / (alturaM * alturaM);
          info = 'IMC = $_peso / ($_altura / 100)^2';
        }
        break;
      case 'Ritmo metabólico basal (RMB)':
        if (_peso <= 0 || _altura <= 0 || globales.edad <= 0) {
          datosCompletos = false;
          mensajeError = 'Por favor ingresa el peso, altura, género y edad para calcular el RMB.';
        } else {
          if (globales.genero == 'Masculino') {
            result = 88.362 + (13.397 * _peso) + (4.799 * _altura) - (5.677 * globales.edad);
            info = 'RMB (Masculino) = 88.362 + (13.397 * $_peso) + (4.799 * $_altura) - (5.677 * ${globales.edad})';
          } else {
            result = 447.593 + (9.247 * _peso) + (3.098 * _altura) - (4.330 * globales.edad);
            info = 'RMB (Femenino) = 447.593 + (9.247 * $_peso) + (3.098 * $_altura) - (4.330 * ${globales.edad})';
          }
        }
        break;
      case 'Porcentaje de cambio de peso':
        if (_peso <= 0 || _pesoAnterior <= 0) {
          datosCompletos = false;
          mensajeError = 'Por favor ingresa el peso actual y el peso anterior para calcular el cambio de peso.';
        } else {
          result = ((_peso - _pesoAnterior) / _pesoAnterior) * 100;
          info = 'Cambio de peso = (($_peso - $_pesoAnterior) / $_pesoAnterior) * 100';
        }
        break;
      case 'Relación cintura-cadera':
        if (_cintura <= 0 || _cadera <= 0) {
          datosCompletos = false;
          mensajeError = 'Por favor ingresa la circunferencia de cintura y cadera para calcular la relación cintura-cadera.';
        } else {
          result = _cintura / _cadera;
          info = 'Relación cintura-cadera = $_cintura / $_cadera';
        }
        break;
      default:
        break;
    }

    if (!datosCompletos) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Faltan datos'),
          content: Text(mensajeError),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _calculatedValue = result;
        _calculationInfo = info;
      });
    }
  }

  void _saveCalculatedData() async {
    try {
      if (_calculatedValue == null || _selectedCalculation == null || !_calculados) {
        _showErrorDialog('No se ha realizado ningún cálculo o el cálculo no es válido.');
        return;
      }

      RegistroFisico bodyData = RegistroFisico(
        tipo: _selectedCalculation!,
        valor: _calculatedValue!,
      );

      await PhysicalDataService.addData(
        context,
        _coleccion,
        bodyData.toJson(),
      );

      _showSuccessDialog();
    } catch (error) {
      print('Error al guardar datos calculados: $error');
      _showErrorDialog('Ha ocurrido un error al guardar los datos.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Registro creado'),
        content: Text('Tu nuevo registro ha sido creado exitosamente.'),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
             Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const PrincipalPage(
                            initialPageIndex: 2,
                          ),
                        ),
                      );
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDropdown(
                hint: 'Selecciona un cálculo',
                value: _selectedCalculation,
                items: _calculations,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCalculation = newValue as String?;
                    _calculatedValue = null;
                    _calculationInfo = null;
                    _calculados = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_selectedCalculation != null && _calculatedValue == null)
                CustomButton(
                  text: 'Calcular',
                  onPressed: _calculateData,
                  icon: Icons.calculate,
                ),
              const SizedBox(height: 20),
              if (_calculatedValue != null && _calculationInfo != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado: $_calculatedValue',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Información del cálculo: $_calculationInfo',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Guardar',
                      onPressed: _saveCalculatedData,
                      icon: Icons.save,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
