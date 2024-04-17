import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';

import 'package:gym_check/src/screens/seguimiento/physical/add_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/data_tracking_widget.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';

import 'package:provider/provider.dart';

class CorporalDataPage extends StatefulWidget {
  const CorporalDataPage({Key? key}) : super(key: key);

  @override
  _CorporalDataPageState createState() => _CorporalDataPageState();
}

class _CorporalDataPageState extends State<CorporalDataPage> {
  String _nick = '';
  int _peso = 0;
  int _altura = 0;
  int _grasa = 0;
  String _fechaPeso = '';
  String _fechaAltura = '';
  String _fechaGrasa = '';
  final String _coleccion = 'Registro-Corporal';
  final Map<String, String> _datos = {
    'peso': 'Kilogramos:',
    'altura': 'Centimetros:',
    'porcentajeGrasa': 'Porcentaje:',
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
            await PhysicalDataService.getLatestPhysicalData(_nick, _coleccion, dato);
        setState(() {
          switch (dato) {
            case 'peso':
              _peso = data['peso'];
              _fechaPeso = data['fecha'];
              break;
            case 'altura':
              _altura = data['altura'];
              _fechaAltura = data['fecha'];
              break;
            case 'porcentajeGrasa':
              _grasa = data['porcentajeGrasa'];
              _fechaGrasa = data['fecha'];
              break;
          }
        });
      }
    } catch (error) {
      print('Error loading user physical data: $error');
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
      ),
    );
  }

  String _getDataValue(String dato) {
    switch (dato) {
      case 'peso':
        return _peso.toString();
      case 'altura':
        return _altura.toString();
      case 'porcentajeGrasa':
        return '$_grasa%';
      default:
        return '';
    }
  }
  String _getDataName(String dato) {
    switch (dato) {
      case 'peso':
        return "Peso";
      case 'altura':
        return "Altura";
      case 'porcentajeGrasa':
        return 'Porcentaje de Grasa';
      default:
        return '';
    }
  }

  String _getDataDate(String dato) {
    switch (dato) {
      case 'peso':
        return _fechaPeso;
      case 'altura':
        return _fechaAltura;
      case 'porcentajeGrasa':
        return _fechaGrasa;
      default:
        return '';
    }
  }

  IconData _getIcon(String dato) {
    switch (dato) {
      case 'peso':
        return Icons.accessibility;
      case 'altura':
        return Icons.height;
      case 'porcentajeGrasa':
        return Icons.opacity;
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDataTrackingContainers(),
          const SizedBox(height: 20),
         CreateButton(
  text: 'Agregar',
  buttonColor: Colors.green,
  onPressed: () {
   _showAddData(context);
      
  },
  iconData: Icons.add,
  iconColor: Colors.white,
),


          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(16),
          //       child: const Text(
          //         'Analizar informacion corporal',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.info),
          //       onPressed: () {},
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

   void _showAddData(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: AddDataPage(tipoDeRegistro: "corporales")
        );
      },
    );
  }
}


