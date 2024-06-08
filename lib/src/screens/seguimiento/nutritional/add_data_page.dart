import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDataPage extends StatefulWidget {
  final String macroName;
  final bool macros;
  final bool agua;
  final bool add;

  AddDataPage({Key? key, required this.macroName, required this.add, required this.macros, required this.agua})
      : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();

  late double _selectedValue = 0;
  final TextEditingController _enteroController = TextEditingController();

  @override
  void initState() {
    super.initState();
   // _enteroController.text = '0';
  }

  @override
  void dispose() {
    _enteroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.add == true)
                  Text(
                    'Agregar ${widget.macroName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                if (widget.add == false)
                  Text(
                    'Restar ${widget.macroName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: 20),
                SizedBox(height: 20.0),
                if(widget.macros == true)
                TextFormField(
                  controller: _enteroController,
                  decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: 'Cantidad en gramos',
                    labelStyle: TextStyle(color: Colors.white),
                   /* enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),*/
                  ),
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una cantidad';
                    }
                    if (double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                      return 'Ingrese una cantidad válida mayor a 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                 if(widget.agua == true)
                TextFormField(
                  controller: _enteroController,
                  decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: 'Cantidad en milliitros',
                    labelStyle: TextStyle(color: Colors.white),
                   /* enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),*/
                  ),
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una cantidad';
                    }
                    if (double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                      return 'Ingrese una cantidad válida mayor a 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = double.tryParse(value) ?? 0;
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
                    if(widget.macros == true)
                    Text(
                      "GR",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    if(widget.agua == true)
                    Text(
                      "ML",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),

                  
                  ],
                ),
                const SizedBox(height: 20),
                if (widget.add == true)
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addData();
                      }
                    },
                    text: 'Agregar',
                    icon: Icons.add,
                  ),
                if (widget.add == false)
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _removeData();
                      }
                    },
                    text: 'Restar',
                    icon: Icons.remove,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addData() async {
    // Mostrar AlertDialog mientras se crea la rutina
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.black, // Fondo negro
          title: Text(
            'Guardando...',
            style: TextStyle(color: Colors.white), // Letras blancas
          ),
          content: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white), // Color del indicador de progreso blanco
          ),
        );
      },
    );

    String macro = _getMacroKey(widget.macroName);

    // Obtener una instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Obtener el valor actual de la macro desde SharedPreferences
    double currentValue = prefs.getDouble(macro) ?? 0.0;

    // Sumar el valor actual con la nueva cantidad seleccionada
    double updatedValue = currentValue + _selectedValue;

    // Guardar el nuevo valor actualizado para la macro seleccionada
    await prefs.setDouble(macro, updatedValue);

    Navigator.of(context).pop(); // Cerrar el dialogo de "Guardando..."

    _showConfirmationDialog('Registro guardado', 'Tu nuevo registro ha sido guardado exitosamente');
  }

  Future<void> _removeData() async {
    // Mostrar AlertDialog mientras se realiza la operación
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.black, // Fondo negro
          title: Text(
            'Restando...',
            style: TextStyle(color: Colors.white), // Letras blancas
          ),
          content: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white), // Color del indicador de progreso blanco
          ),
        );
      },
    );

    String macro = _getMacroKey(widget.macroName);

    // Obtener una instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Obtener el valor actual de la macro desde SharedPreferences
    double currentValue = prefs.getDouble(macro) ?? 0.0;

    // Restar el valor actual con la nueva cantidad seleccionada
    double updatedValue = currentValue - _selectedValue;

    // Asegurar que el valor actualizado no sea negativo
    updatedValue = updatedValue < 0 ? 0 : updatedValue;

    // Guardar el nuevo valor actualizado para la macro seleccionada
    await prefs.setDouble(macro, updatedValue);

    Navigator.of(context).pop(); // Cerrar el dialogo de "Restando..."

    _showConfirmationDialog('Registro actualizado', 'Tu registro ha sido actualizado exitosamente');
  }

  String _getMacroKey(String macroName) {
    switch (macroName) {
      case "Proteínas":
        return "proteinData";
      case "Carbohidratos":
        return "carbData";
      case "Grasas":
        return "fatData";
      case "Agua":
        return "waterData";
      default:
        return "";
    }
  }

  void _showConfirmationDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Fondo negro
          title: Text(
            title,
            style: const TextStyle(color: Colors.white), // Letras blancas
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
  }
}
