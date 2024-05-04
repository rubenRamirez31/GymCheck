import 'dart:ffi';

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
  int diasrest = 1;
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
    //diasrest = calcularDiasRestantes(_meta['fechaFinalizacion']) as int;
    
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
     //diasrest = calcularDiasRestantes(_meta['fechaFinalizacion']) as int;
    print(diasrest);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              modificarDatos(context, _meta['id']);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
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
                  const CircularProgressIndicator()
                else if (_meta.isNotEmpty)
                  _buildMetas()
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectGoalPage()),
                      );
                    },
                    child: const Text('Crear'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaPrincipalInfo(),
        const SizedBox(
          height: 20,
          width: 20,
        ),
        _buildMetasDiarias()
      ],
    );
  }

  Widget _buildMetaPrincipalInfo() {
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context)
              .size
              .width, // Ancho de la pantalla menos el padding del widget principal
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 70, 70, 70), // Color más fuerte
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Meta Principal:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                 
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20), // Espacio entre la fila y el contenedor
        Container(
          width: MediaQuery.of(context)
              .size
              .width, // Ancho de la pantalla menos el padding del widget principal
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 70, 70, 70), // Color más fuerte
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow('Tipo de meta', '${_meta['tipoMeta']}'),
              _buildDataRow('Duración', '${_meta['duracion']} días'),
              _buildDataRow(
                  'Fecha de Inicio', _formatDate(_meta['fechaInicio'])),
              _buildDataRow('Fecha de Finalización',
                  _formatDate(_meta['fechaFinalizacion'])),
              _buildDataRow('Días restantes',  _calcularDiasRestantes(_meta['fechaFinalizacion']).toString() ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetasDiarias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context)
              .size
              .width, // Ancho de la pantalla menos el padding del widget principal
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 70, 70, 70), // Color más fuerte
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Metas diarias:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20), // Espacio entre la fila y el contenedor
        Container(
          width: MediaQuery.of(context)
              .size
              .width, // Ancho de la pantalla menos el padding del widget principal
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 70, 70, 70), // Color más fuerte
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow('Duración', '${_meta['duracion']} días'),
              _buildDataRow(
                  'Fecha de Inicio', _formatDate(_meta['fechaInicio'])),
              _buildDataRow('Fecha de Finalización',
                  _formatDate(_meta['fechaFinalizacion'])),
              _buildDataRow('Tipo de Meta', _meta['tipoMeta']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String macro, String cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$macro:',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              cantidad,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 59, 59, 59),
        borderRadius: BorderRadius.circular(5), // Bordes redondeados
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void modificarDatos(BuildContext context, String id) async {
    macros = calcularMacros(_meta['tipoMeta'], _datosCorporales);

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

  Map<String, double> calcularMacros(
      String tipoMeta, Map<String, dynamic> datosCorporales) {
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
      'carbohidratos':
          double.parse(macros['carbohidratos']!.toStringAsFixed(2)),
      'grasas': double.parse(macros['grasas']!.toStringAsFixed(2)),
    };

    return roundedMacros;
  }

  String _formatDate(String date) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }

  int _calcularDiasRestantes(String fechaFinalizacionString)  {
  // Obtener la fecha actual
  DateTime fechaActual = DateTime.now();

  // Convertir la fecha de finalización de String a DateTime
  DateTime fechaFinalizacion = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS").parse(fechaFinalizacionString);

  // Calcular la diferencia en días
  Duration diferencia = fechaFinalizacion.difference(fechaActual);
  int diasRestantes = diferencia.inDays;

  return diasRestantes;
}
}
