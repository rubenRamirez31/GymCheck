import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/add_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/view_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/settings/macros_settings.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/data_nutritional_tracking_widget.dart';
import 'package:gym_check/src/services/nutritional_tracking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterDataPage extends StatefulWidget {
  const WaterDataPage({Key? key}) : super(key: key);

  @override
  _WaterDataPageState createState() => _WaterDataPageState();
}

class _WaterDataPageState extends State<WaterDataPage> {
  double waterData = 0.0; // Valor inicial para el agua
  double meta = 0;

  @override
  void initState() {
    super.initState();
    _loadWaterData();
    fetchTrackingData();
  }

  Future<void> _loadWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterData = prefs.getDouble('waterData') ?? 0.0;
    });
  }

    Future<void> fetchTrackingData() async {
    try {
      final result = await NutritionalService.getTrackingData(context);
      setState(() {
        //  trackingData = result['trackingData'];
        meta = result['trackingData']['agua'];
      });

    
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
                  'Mi Consumo de Agua',
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
            icon: Icons.local_drink, // Icono para el agua
            name: 'Agua',
            ter: 'ml',
            data: waterData,
            meta:meta, // Meta diaria de agua en mililitros (puedes ajustarla)
            verMas: () => _showViewData(context, 'Agua'),
            agregar: () => _showAddData(context, 'Agua', true),
            quitar: () => _showAddData(context, 'Agua', false),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
            
              CustomButton(
                icon: Icons.edit,
                text: "Modificar consumo diario",
                onPressed: () {
                  _settings(context);
                },
              ),
                 CustomButton(
                icon: Icons.edit,
                text: "Guardar registro",
                onPressed: () {
                 _saveNutritionalData(context,waterData );
                },
              )
            ],
          ),
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

  void _showAddData(BuildContext context, String data, bool add) {
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
            add: add,
            macros: false,
            agua: true,
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
          child: MacroSettingsWidget(macro: false, agua: true,),
        );
      },
    );
  }

  Future<void> _saveNutritionalData(BuildContext context, double water,
    ) async {
    try {
      final Map<String, double> data = {
        'Agua': water,
      
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
          waterData = 0.0;
       
        });

        // Reiniciar los valores de los shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('waterData', 0.0);
      

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dato guardado exitosamente')));
      }
    } catch (error) {
      print('Error al guardar los datos nutricionales: $error');
    }
  }
}
