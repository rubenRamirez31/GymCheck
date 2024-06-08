import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_goal_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/add_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/view_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/settings/macros_settings.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/data_nutritional_tracking_widget.dart';
import 'package:gym_check/src/services/nutritional_tracking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MacrosDataPage extends StatefulWidget {
  const MacrosDataPage({Key? key}) : super(key: key);

  @override
  _MacrosDataPageState createState() => _MacrosDataPageState();
}

class _MacrosDataPageState extends State<MacrosDataPage> {
  double proteinData = 0.0; // Valor inicial para las proteínas
  double carbData = 0.0; // Valor inicial para los carbohidratos
  double fatData = 0.0; // Valor inicial para las grasas

  Map<String, dynamic>? trackingData;
  String? errorMessage;
  List<dynamic>? macrosList;

  @override
  void initState() {
    super.initState();

    fetchTrackingData();
    _loadMacroData();
  }

  Future<void> _loadMacroData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      proteinData = prefs.getDouble('proteinData') ?? 0.0;
      carbData = prefs.getDouble('carbData') ?? 0.0;
      fatData = prefs.getDouble('fatData') ?? 0.0;
    });
  }

  Future<void> fetchTrackingData() async {
    try {
      final result = await NutritionalService.getTrackingData(context);
      setState(() {
        //  trackingData = result['trackingData'];
        macrosList = result['trackingData']['macros'];
      });

      print(macrosList);
    } catch (error) {
      print('Error al cargar los datos de fuerza: $error');
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Mis Macros',
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
                onPressed: () {
                  _settings(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          DataNutritionalTracking(
            icon: Icons.emoji_food_beverage, // Icono para las proteínas
            name: 'Proteínas',
            ter: 'gr',
            data: proteinData,
            meta: macrosList != null ? macrosList![0] : 0,
            verMas: () => _showViewData(context, 'Proteínas'),
            agregar: () => _showAddData(context, 'Proteínas', true),
            quitar: () => _showAddData(context, 'Proteínas', false),
          ),
          DataNutritionalTracking(
            icon: Icons.local_pizza, // Icono para los carbohidratos
            name: 'Carbohidratos',
            ter: 'gr',
            data: carbData,
            meta: macrosList != null ? macrosList![1] : 0,
            verMas: () => _showViewData(context, 'Carbohidratos'),
            agregar: () => _showAddData(context, 'Carbohidratos', true),
            quitar: () => _showAddData(context, 'Carbohidratos', false),
          ),
          DataNutritionalTracking(
            icon: Icons.fastfood, // Icono para las grasas
            name: 'Grasas',
            ter: 'gr',
            data: fatData,

            meta: macrosList != null ? macrosList![2] : 0,
            verMas: () => _showViewData(context, 'Grasas'),
            agregar: () => _showAddData(context, 'Grasas', true),
            quitar: () => _showAddData(context, 'Grasas', false),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              CustomButton(
                  icon: Icons.calculate,
                  text: "Calcular macros",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectGoalPage()),
                    );
                  }),
              CustomButton(
                icon: Icons.edit,
                text: "Agrear macros manualmente",
                onPressed: () {
                  _settings(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void _showViewData(BuildContext context, String data) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: ViewDataPage(
            data: data,
          ),
        );
      },
    );
  }

  void _showAddData(BuildContext context, String data, bool addd) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.60,
          child: AddDataPage(
            macroName: data,
            add: addd,
            macros: true,
            agua: false,
          ),
        );
      },
    );
  }

  void _settings(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: MacroSettingsWidget(macro: true, agua: false,),
        );
      },
    );
  }

  Future<void> _saveNutritionalData(BuildContext context, double proteinValue,
      double carbValue, double fatValue) async {
    try {
      final Map<String, double> data = {
        'Proteínas': proteinValue,
        'Carbohidratos': carbValue,
        'Grasas': fatValue,
      };

      // Llamar al servicio para agregar los datos nutricionales
      final result = await NutritionalService.addNutritionalData(context, data);

      // Manejar el resultado
      if (result.containsKey('error')) {
        // Mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar los datos')));
      } else {
        // Actualizar el estado y mostrar un mensaje de éxito
        setState(() {
          proteinData = 0.0;
          carbData = 0.0;
          fatData = 0.0;
        });

        // Reiniciar los valores de los shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('proteinData', 0.0);
        await prefs.setDouble('carbData', 0.0);
        await prefs.setDouble('fatData', 0.0);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Datos guardados exitosamente')));
      }
    } catch (error) {
      print('Error al guardar los datos nutricionales: $error');
    }
  }
}
