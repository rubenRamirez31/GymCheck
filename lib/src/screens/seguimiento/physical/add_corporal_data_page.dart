import 'package:flutter/material.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_drop_dowm_wiget.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/decimal_slider_widget.dart';
import 'package:gym_check/src/services/physical_data_service.dart';

// ignore: must_be_immutable
class AddCorporalDataPage extends StatefulWidget {
  bool? goal;
  final String? selectedFieldType;

  AddCorporalDataPage({Key? key, this.goal, this.selectedFieldType});

  @override
  _AddCorporalDataPageState createState() => _AddCorporalDataPageState();
}

class _AddCorporalDataPageState extends State<AddCorporalDataPage> {
  // Aquí puedes agregar tu lógica para la página de añadir datos corporales

  String? _selectedField;
  late double _selectedValue = 0;
  late int _selectedEntero = 0;
  late int _selectedDecimal = 0;

  @override
  void initState() {
    super.initState();
    _selectedEntero = 0; // Inicializa el valor seleccionado
    _selectedDecimal = 0; // Inicializa el valor seleccionado
    _selectedValue = 0;
    // Inicializa _selectedField con selectedFieldType si está disponible
    if (widget.selectedFieldType != null) {
      _selectedField = _getCampoPorSelectedFieldType(widget.selectedFieldType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //if (widget.tipoDeRegistro == "corporales")
              if (widget.selectedFieldType == null)
                CustomDropdown(
                  hint: 'Seleccionar',
                  value: _selectedField,
                  items: _getCamposPorRegistro(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedField = newValue;
                    });
                  },
                ),
              if (widget.selectedFieldType != null)
                Text(
                  _getCampoPorSelectedFieldType(widget.selectedFieldType!),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              if (widget.selectedFieldType != null)
                Text(
                  _getDescription(widget.selectedFieldType!.toLowerCase()),
                  style: const TextStyle(color: Colors.white),
                ),

              // if (widget.tipoDeRegistro == "fuerza") _builExercie(),
              const SizedBox(height: 20),
              if (_selectedField != null) ...[
                Text(
                  _getDescription(_selectedField!),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                DecimalSlider(
                  selectedDecimal: _selectedEntero,
                  maxValue: 300,
                  onChanged: (value) {
                    setState(() {
                      _selectedEntero = value.toInt();
                      _updateSelectedValue();
                    });
                  },
                ),
                DecimalSlider(
                  selectedDecimal: _selectedDecimal,
                  maxValue: 99,
                  onChanged: (value) {
                    setState(() {
                      _selectedDecimal = value;
                      _updateSelectedValue();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedValue.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const Text(
                      " ",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      _getTerminacionPorCampo(_selectedField!),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    _guardarDatos(context, _getTipoPorCampo(_selectedField!));
                  },
                  text: 'Agregar',
               
               
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _updateSelectedValue() {
    setState(() {
      _selectedValue = _selectedEntero + (_selectedDecimal / 100);
    });
  }

  void _guardarDatos(BuildContext context, String tipo) async {
    try {
      // Mostrar AlertDialog mientras se crea la rutina
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: Text(
              'Subiendo...',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Color del indicador de progreso blanco
            ),
          );
        },
      );

      _selectedValue = double.parse("$_selectedEntero.$_selectedDecimal");

      double valor = _selectedValue; // Utiliza el valor seleccionado

      RegistroFisico bodyData = RegistroFisico(tipo: tipo, valor: valor);

      // String coleccion = _getColeccion();

      PhysicalDataService.addData(
          context, "Registro-Corporal", bodyData.toJson());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Registro creado',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tu nuevo registro ha sido creado exitosamente',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (widget.goal == true) {
                      setState(() {});
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    }
                    // Reinicia la página
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const PrincipalPage(
                          initialPageIndex: 2,
                        ),
                      ),
                    );
                  },
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          );
        },
      );

      
    } catch (error) {
      print('Error al guardar datos: $error');
    }
  }

  List<String> _getCamposPorRegistro() {
    return [
      'Peso (kg)',
      'Altura (cm)',
      'Grasa Corporal (%)',
      'Circunferencia de Cintura (cm)'
    ];
  }

  String _getDescription(String campo) {
    switch (campo) {
      case 'Peso (kg)':
        return 'Por favor, ingrese su peso actual en kilogramos.';
      case 'Altura (cm)':
        return 'Por favor, ingrese su altura actual en centímetros.';
      case 'Grasa Corporal (%)':
        return 'Por favor, ingrese su porcentaje de grasa corporal actual.';
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

  String _getCampoPorSelectedFieldType(String selectedFieldType) {
    switch (selectedFieldType) {
      case 'Peso':
        return 'Peso (kg)';
      case 'Altura':
        return 'Altura (cm)';
      case 'Grasa Corporal':
        return 'Grasa Corporal';
      case 'Circunferencia de Cintura':
        return 'Circunferencia de Cintura';
      case 'Circunferencia de Cuello':
        return 'Circunferencia de Cuello';
      case 'Circunferencia de Cadera':
        return 'Circunferencia de Cadera';
      case 'Índice de Masa Corporal (IMC)':
        return 'imc';
      default:
        return '';
    }
  }

  String _getTerminacionPorCampo(String campo) {
    switch (campo) {
      case 'Peso (kg)':
        return 'Kg';
      case 'Altura (cm)':
        return 'Cm';
      case 'Grasa Corporal (%)':
        return '%';
      case 'Circunferencia de Cintura (cm)':
        return 'cm';
      case 'Circunferencia de Cuello (cm)':
        return 'cm';
      case 'Circunferencia de Cadera (cm)':
        return 'cm';
      case 'Índice de Masa Corporal (IMC)':
        return 'imc';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
