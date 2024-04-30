import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/seguimiento/goals/select_goal_page.dart';
import 'package:gym_check/src/services/goals_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ViewMainGoalWidget extends StatefulWidget {
  @override
  _ViewMainGoalWidgetState createState() => _ViewMainGoalWidgetState();
}

class _ViewMainGoalWidgetState extends State<ViewMainGoalWidget> {
  Map<String, dynamic> _meta = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMetaPrincipalActiva();
  }

  Future<void> _loadMetaPrincipalActiva() async {
    final meta = await GoalsService.obtenerMetaPrincipalActiva(context);
    setState(() {
      _meta = meta;
      _isLoading = false;
    });

    print(_meta);
  }

  @override
  Widget build(BuildContext context) {
    print("_meta");
    print(_meta);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : _meta.isNotEmpty
                  ? _buildMetaInfo()
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SelectGoalPage()), // Directamente proporcionamos la instancia de la clase SecondPage
                        );
                      },
                      child: Text('Crear'),
                    ),
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
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
        ElevatedButton(
          onPressed: () async {
            modificarDatos(context, _meta['id']);
          },
          child: Text('Modificar Datos Corporales'),
        ),
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

  String _formatDate(String date) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }


  void modificarDatos(BuildContext context, String id) async {
  // Verificar si hoy es domingo (día de la semana 7 en Dart, donde el domingo es el primer día)
  if (DateTime.now().weekday == 7) {
    // Nuevos datos corporales
    Map<String, dynamic> nuevosDatosCorporales = {
      'duracion': 90,
      'datosCorporalesVariables': {
        'altura': 172.0,
        'peso': 82,
      },
    };

    // Llama al servicio para actualizar los datos corporales
    try {
      await GoalsService.modificarMetaPrincipal(context, id, nuevosDatosCorporales);
      print('Datos corporales actualizados con éxito');
    } catch (error) {
      print('Error al actualizar los datos corporales: $error');
    }
  } else {
    print('Hoy no es domingo, no se ejecuta la modificación de datos');
  }
}

}
