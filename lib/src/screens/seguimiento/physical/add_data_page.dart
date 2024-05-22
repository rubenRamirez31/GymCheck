import 'package:flutter/material.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_drop_dowm_wiget.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:numberpicker/numberpicker.dart'; // Importa NumberPicker

class AddDataPage extends StatefulWidget {
  bool? goal;
  final String tipoDeRegistro;

  AddDataPage({required this.tipoDeRegistro, this.goal});

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

              // DropdownButton<String>(
              //   value: _selectedField,
              //   hint: const Text('Seleccionar tipo de dato'),
              //   items: _getCamposPorRegistro().map((campo) {
              //     return DropdownMenuItem<String>(
              //       value: campo,
              //       child: Text(campo),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     setState(() {
              //       _selectedField = newValue;
              //     });
              //   },
              // ),
              const SizedBox(height: 20),
              if (_selectedField != null) ...[
                Text(
                  _getDescription(_selectedField!),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildSelectorEntero(),
                // const SizedBox(height: 10),
                _buildSelectorDecimal(),
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
                    _guardarDatos(context);
                  },
                  text:'Agregar',
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorEntero() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Slider(
            activeColor: const Color.fromARGB(255, 25, 57, 94),
            value: _selectedEntero.toDouble(),
            min: 0,
            max: 200,
            divisions: 200,
            label: _selectedEntero.toString(),
            onChanged: (value) {
              setState(() {
                _selectedEntero = value.toInt();
                _updateSelectedValue();
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(
                _selectedEntero.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorDecimal() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Slider(
            activeColor: const Color.fromARGB(255, 25, 57, 94),
            value: _selectedDecimal.toDouble(),
            min: 0,
            max: 99,
            divisions: 99,
            label: _selectedDecimal.toString(),
            onChanged: (value) {
              setState(() {
                _selectedDecimal = value.toInt();
                _updateSelectedValue();
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(
                _selectedDecimal.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateSelectedValue() {
    setState(() {
      _selectedValue = _selectedEntero + (_selectedDecimal / 100);
    });
  }

  void _guardarDatos(BuildContext context) async {
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
      String tipo = _getTipoPorCampo(_selectedField!);

      RegistroFisico bodyData = RegistroFisico(tipo: tipo, valor: valor);

      String coleccion = _getColeccion();

      final response = await PhysicalDataService.addData(
          context, coleccion, bodyData.toJson());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Dato creada',
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

                    if(widget.goal == true){
                        // Cerrar el AlertDialog
            Navigator.of(context).pop();

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
