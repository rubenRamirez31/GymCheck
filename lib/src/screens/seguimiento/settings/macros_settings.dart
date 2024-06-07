import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/services/nutritional_tracking_service.dart';

class MacroSettingsWidget extends StatefulWidget {
  @override
  _MacroSettingsWidgetState createState() => _MacroSettingsWidgetState();
}

class _MacroSettingsWidgetState extends State<MacroSettingsWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();

  Map<String, dynamic>? trackingData;
  String? errorMessage;
  List<dynamic>? macrosList;


  @override
  void initState() {
    super.initState();
 
    fetchTrackingData();
    
  }
  @override
  void dispose() {
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final newMacros = {
        'macros': [
          double.parse(_proteinController.text),
          double.parse(_carbsController.text),
          double.parse(_fatsController.text),
        ]
      };

      final result =
          await NutritionalService.updateTrackingData(context, newMacros);

           showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Macros guardados',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tu nuevas macros han sido guardados exitosamente ',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                  

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


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Error al guardar')),
      );
    }
  }

  Future<void> fetchTrackingData() async {
   
    try {
      final result = await NutritionalService.getTrackingData(context);
      setState(() {
        // Asignar los resultados a macrosList
        macrosList = result['trackingData']['macros'];

        // Verificar si macrosList no es nulo y tiene la longitud correcta
        if (macrosList != null && macrosList!.length == 3) {
          // Asignar los valores de las macros a los controladores
          _proteinController.text = macrosList![0].toString();
          _carbsController.text = macrosList![1].toString();
          _fatsController.text = macrosList![2].toString();
        }
      });
    } catch (error) {
      print('Error al cargar los datos de fuerza: $error');
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Ajustar mis macros',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
                TextFormField(
                  controller: _proteinController,
                  decoration: const InputDecoration(
                    labelText: 'Proteínas (g)',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una meta';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _carbsController,
                  decoration: const InputDecoration(
                    labelText: 'Carbohidratos (g)',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una meta';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fatsController,
                  decoration: const InputDecoration(
                    labelText: 'Grasas (g)',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una meta';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                    onPressed: _saveSettings,
                    text: 'Guardar',
                    icon: Icons.save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
