import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/seguimiento/physical/add_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/data_tracking_widget.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';
import 'package:provider/provider.dart';

class AntropometricDataPage extends StatefulWidget {
  const AntropometricDataPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AntropometricDataPageState createState() => _AntropometricDataPageState();
}

class _AntropometricDataPageState extends State<AntropometricDataPage> {
  String _nick = '';
  double _circunferenciaCuello = 0;
  double _circunferenciaCadera = 0;
  double _imc = 0.0;
  String _fechaCircunferenciaCuello = '';
  String _fechaCircunferenciaCadera = '';
  String _fechaIMC = '';
  final String _coleccion = 'Registro-Antropometrico';
  final Map<String, String> _datos = {
    'circunferenciaCuello': 'Circunferencia de Cuello:',
    'circunferenciaCadera': 'Circunferencia de Cadera:',
    'imc': 'Índice de Masa Corporal:',
  };

  @override
  void initState() {
    super.initState();
    _loadUserDataLastDataPhysical();
  }

  Future<void> _loadUserDataLastDataPhysical() async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      setState(() {
        _nick = userData['nick'];
      });

      for (String dato in _datos.keys) {
        Map<String, dynamic> data =
            await PhysicalDataService.getLatestPhysicalData(context, _coleccion, dato);
        setState(() {
          switch (dato) {
            case 'circunferenciaCuello':
              _circunferenciaCuello = data['circunferenciaCuello'];
              _fechaCircunferenciaCuello = data['fecha'];
              break;
            case 'circunferenciaCadera':
              _circunferenciaCadera = data['circunferenciaCadera'];
              _fechaCircunferenciaCadera = data['fecha'];
              break;
            case 'imc':
              _imc = data['imc'];
              _fechaIMC = data['fecha'];
              break;
          }
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error loading user antropometric data: $error');
    }
  }

  Widget _buildDataTrackingContainers() {
    return Column(
      children: _datos.entries
          .map(
            (entry) {
              String name = entry.key;
              String dataType = entry.value;
              String data = _getDataValue(name);
              String nameView = _getDataName(name);
              String lastRecordDate = _getDataDate(name);
              IconData icon = _getIcon(name);

              // Check if data is null, if so, return an empty container
                  if (lastRecordDate.isEmpty) {
                return const SizedBox();
              }
          

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _buildDataTrackingContainer(
                  nameView,
                  dataType,
                  data,
                  lastRecordDate,
                  icon,
                ),
              );
            },
          )
          .toList(),
    );
  }

  Widget _buildDataTrackingContainer(String name, String dataType, String data,
      String lastRecordDate, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTracking(
        icon: icon,
        name: name,
        dataType: dataType,
        data: data,
        lastRecordDate: lastRecordDate,
        coleccion: 'Registro-Antropometrico',
      ),
    );
  }

  String _getDataValue(String dato) {
    switch (dato) {
      case 'circunferenciaCuello':
        return _circunferenciaCuello.toString();
      case 'circunferenciaCadera':
        return _circunferenciaCadera.toString();
      case 'imc':
        return _imc.toStringAsFixed(2);
      default:
        return '';
    }
  }

  String _getDataName(String dato) {
    switch (dato) {
      case 'circunferenciaCuello':
        return "Circunferencia de Cuello";
      case 'circunferenciaCadera':
        return "Circunferencia de Cadera";
      case 'imc':
        return 'Índice de Masa Corporal';
      default:
        return '';
    }
  }

  String _getDataDate(String dato) {
    switch (dato) {
      case 'circunferenciaCuello':
        return _fechaCircunferenciaCuello;
      case 'circunferenciaCadera':
        return _fechaCircunferenciaCadera;
      case 'imc':
        return _fechaIMC;
      default:
        return '';
    }
  }

  IconData _getIcon(String dato) {
    switch (dato) {
      case 'circunferenciaCuello':
        return Icons.accessibility;
      case 'circunferenciaCadera':
        return Icons.accessibility_new;
      case 'imc':
        return Icons.monitor_weight;
      default:
        return Icons.error;
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
                  'Mis Registros',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDataTrackingContainers(),
          const SizedBox(height: 20),
          CreateButton(
            textColor: Colors.white,
            text: 'Agregar',
            buttonColor: Colors.green,
            onPressed: () {
              _showAddData(context);
             
            },
            iconData: Icons.add,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

   void _showAddData(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
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
          child: AddDataPage(tipoDeRegistro: "antropométricos"),
        );
      },
    );
  }
}
