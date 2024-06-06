import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/decimal_slider_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDataPage extends StatefulWidget {
  final String macroName;
  final bool add;

   AddDataPage({Key? key, required this.macroName, required this.add})
      : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Text(
              'Seleccionar cantidad de ${widget.macroName}:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
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
                  "GR",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.add == true)
              CustomButton(
                onPressed: () {
                  _addData();
                },
                text: 'Agregar',
                icon: Icons.add,
              ),
            if (widget.add == false)
              CustomButton(
                onPressed: () {
                  _removeData();
                },
                text: 'Restar',
                icon: Icons.remove,
              ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedValue() {
    setState(() {
      _selectedValue = _selectedEntero + (_selectedDecimal / 100);
    });
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
    String macro = "";

// Determinar el nombre de la preferencia según el tipo de macro
    if (widget.macroName == "Proteínas") {
      macro = "proteinData";
    } else if (widget.macroName == "Carbohidratos") {
      macro = "carbData";
    } else if (widget.macroName == "Grasas") {
      macro = "fatData";
    }

// Obtener una instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

// Obtener el valor actual de la macro desde SharedPreferences
    double currentValue = prefs.getDouble(macro) ?? 0.0;

// Sumar el valor actual con la nueva cantidad seleccionada
    double updatedValue = currentValue + _selectedValue;

// Guardar el nuevo valor actualizado para la macro seleccionada
    await prefs.setDouble(macro, updatedValue);

    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Registro guardado',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tu nuevo registro ha sido guardado exitosamente',
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
        });

    // Implementar la lógica para guardar la cantidad seleccionada
    print('Cantidad de ${widget.macroName}: $_selectedValue gr guardada.');
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

  String macro = "";

  // Determinar el nombre de la preferencia según el tipo de macro
  if (widget.macroName == "Proteínas") {
    macro = "proteinData";
  } else if (widget.macroName == "Carbohidratos") {
    macro = "carbData";
  } else if (widget.macroName == "Grasas") {
    macro = "fatData";
  }

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

  // Mostrar AlertDialog de confirmación
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black, // Fondo negro
        title: const Text(
          'Registro actualizado',
          style: TextStyle(color: Colors.white), // Letras blancas
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tu registro ha sido actualizado exitosamente',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reiniciar la página
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

  // Implementar la lógica para restar la cantidad seleccionada
  print('Cantidad de ${widget.macroName}: $_selectedValue gr restada.');
}

}
