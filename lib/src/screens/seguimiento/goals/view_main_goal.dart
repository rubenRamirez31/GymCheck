import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_goal_page.dart';
import 'package:gym_check/src/services/goals_service.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ViewMainGoalWidget extends StatefulWidget {
  @override
  _ViewMainGoalWidgetState createState() => _ViewMainGoalWidgetState();
}

class _ViewMainGoalWidgetState extends State<ViewMainGoalWidget> {
  Map<String, dynamic> _meta = {};
  bool _isLoading = true;
  final String _coleccion = 'Registro-Corporal';
  late Map<String, double> macros;
    double _peso = 0;
  double _altura = 0;
  final Map<String, String> _datosCorporales = {
    'peso': 'Kilogramos:',
    'altura': 'Centimetros:',
  };

  @override
  void initState() {
    super.initState();
        _loadUserDataLastDataPhysical();
    _loadMetaPrincipalActiva();

  }

  Future<void> _loadMetaPrincipalActiva() async {
    final meta = await GoalsService.obtenerMetaPrincipalActiva(context);
    setState(() {
      _meta = meta;
      _isLoading = false;
    });

  
  }

@override
Widget build(BuildContext context) {
  print(_peso);
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xff0C1C2E),
      title: const Text(
        'Metas',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
        ),
      ),
      automaticallyImplyLeading: false, // Esto elimina el botón de retorno
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {
            modificarDatos(context, _meta['id']);
          },
        ),
        IconButton(
          icon: Icon(Icons.info, color: Colors.white),
          onPressed: () {
            // Acción al presionar el botón de información
          },
        ),
      ],
    ),
    body: Container(
      color: const Color.fromARGB(255, 18, 18, 18),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading)
                CircularProgressIndicator()
              else if (_meta.isNotEmpty)
                _buildMetaPrincipalInfo()
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectGoalPage()),
                    );
                  },
                  child: Text('Crear'),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildMetaPrincipalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoContainer('Duración', '${_meta['duracion']} días'),
        SizedBox(height: 10),
        _buildInfoContainer(
            'Fecha de Inicio', _formatDate(_meta['fechaInicio'])),
        SizedBox(height: 10),
        _buildInfoContainer(
            'Fecha de Finalización', _formatDate(_meta['fechaFinalizacion'])),
        SizedBox(height: 10),
        _buildInfoContainer('Tipo de Meta', _meta['tipoMeta']),
        
      ],
    );
  }

  Widget _buildInfoContainer(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      color: const Color.fromARGB(255, 59, 59, 59),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void modificarDatos(BuildContext context, String id) async {

   macros= calcularMacros(_meta['tipoMeta'], _datosCorporales);

    
    // Verificar si hoy es domingo (día de la semana 7 en Dart, donde el domingo es el primer día)
   // if (DateTime.now().weekday == 7) {
      // Nuevos datos corporales
      Map<String, dynamic> nuevosDatosCorporales = {
        'duracion': 90,
        'datosCorporalesVariables': {
          'altura': _altura,
          'peso': _peso,
        },
        'macros': {
          'carbohidratos': macros['carbohidratos'],
          'grasas': macros['grasas'],
          'proteinas': macros['proteinas'],
        },
      };

      // Llama al servicio para actualizar los datos corporales
      try {
        await GoalsService.modificarMetaPrincipal(
            context, id, nuevosDatosCorporales);
        print('Datos corporales actualizados con éxito');
      } catch (error) {
        print('Error al actualizar los datos corporales: $error');
      }
    //} else {
     // print('Hoy no es domingo, no se ejecuta la modificación de datos');
    //}
  }

  Future<void> _loadUserDataLastDataPhysical() async {
    try {
     
      for (String dato in _datosCorporales.keys) {
        Map<String, dynamic> data =
            await PhysicalDataService.getLatestPhysicalData(
                context, _coleccion, dato);

        setState(() {
          switch (dato) {
            case 'peso':
              _peso = data['peso'] ?? 0;
              break;
            case 'altura':
              _altura = data['altura'] ?? 0;
              break;
          }
        });
      }
    } catch (error) {
      print('Error loading user physical data: $error');
    }
  }

Map<String, double> calcularMacros(String tipoMeta, Map<String, dynamic> datosCorporales) {
  final rangosValores = {
    'Pérdida de peso': {
      'proteinas': {'min': 1.2, 'max': 2.0},
      'carbohidratos': {'min': 40, 'max': 55},
      'grasas': {'min': 20, 'max': 30}
    },
    'Aumento de masa muscular': {
      'proteinas': {'min': 1.6, 'max': 2.2},
      'carbohidratos': {'min': 45, 'max': 60},
      'grasas': {'min': 25, 'max': 35}
    },
    'Definición muscular': {
      'proteinas': {'min': 1.8, 'max': 2.4},
      'carbohidratos': {'min': 35, 'max': 50},
      'grasas': {'min': 20, 'max': 30}
    },
    'Mantener peso': {
      'proteinas': {'min': 1.0, 'max': 1.5},
      'carbohidratos': {'min': 45, 'max': 60},
      'grasas': {'min': 20, 'max': 35}
    },
  };

  final rangoValoresMeta = rangosValores[tipoMeta];
  final proteinaMin = rangoValoresMeta!['proteinas']!['min']!;
  final carbohidratosMin = rangoValoresMeta['carbohidratos']!['min']!;
  final grasasMin = rangoValoresMeta['grasas']!['min']!;

  

//condicionar si es hombre o mujer el ulttimo dato para hombre es 5 y mujer es - 161
  final double tmb = 10 * _peso + 6.25 * _altura - 5 * 21 + 5;
  final double tdee = tmb * 2.4; // Utilizando una PAL predeterminada de 2.4

  final macros = {
    'proteinas': (1.2 * _peso),
    'carbohidratos': (((carbohidratosMin / 100) * tdee / 4)),
    'grasas': (((grasasMin / 100) * tdee / 9)),
  };
  

  // Redondear los valores a 2 decimales
  final roundedMacros = {
    'proteinas': double.parse(macros['proteinas']!.toStringAsFixed(2)),
    'carbohidratos': double.parse(macros['carbohidratos']!.toStringAsFixed(2)),
    'grasas': double.parse(macros['grasas']!.toStringAsFixed(2)),
  };

  return roundedMacros;
}


  String _formatDate(String date) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }
}
