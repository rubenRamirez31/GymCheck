import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/physical/add_corporal_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/data_physical_tracking_widget.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';

class CorporalDataPage extends StatefulWidget {
  const CorporalDataPage({Key? key}) : super(key: key);

  @override
  _CorporalDataPageState createState() => _CorporalDataPageState();
}

class _CorporalDataPageState extends State<CorporalDataPage> {
  double _peso = 0;
  double _altura = 0;
  double _grasa = 0;
  String _fechaPeso = '';
  String _fechaAltura = '';
  String _fechaGrasa = '';
  final String _coleccion = 'Registro-Corporal';
  final Map<String, String> _datos = {
    'peso': 'Kilogramos:',
    'altura': 'Centimetros:',
    'grasaCorporal': 'Porcentaje:',
  };

  @override
  void initState() {
    super.initState();
    _loadUserDataLastDataPhysical();
  }

  Future<void> _loadUserDataLastDataPhysical() async {
    try {
      for (String dato in _datos.keys) {
        Map<String, dynamic> data =
            await PhysicalDataService.getLatestPhysicalData(
                context, _coleccion, dato);
        setState(() {
          switch (dato) {
            case 'peso':
              _peso = data['peso'] ?? 0;
              _fechaPeso = data['fecha'] ?? '';
              break;
            case 'altura':
              _altura = data['altura'] ?? 0;
              _fechaAltura = data['fecha'] ?? '';
              break;
            case 'grasaCorporal':
              _grasa = data['grasaCorporal'] ?? 0;
              _fechaGrasa = data['fecha'] ?? '';
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
      children: _datos.entries.map(
        (entry) {
          String name = entry.key;
          String dataType = entry.value;
          String data = _getDataValue(name);
          String nameView = _getDataName(name);
          String lastRecordDate = _getDataDate(name);
          IconData icon = _getIcon(name);

          if (lastRecordDate.isEmpty) {
            return const SizedBox();
          }

          return  _buildDataTrackingContainer(
              nameView,
              dataType,
              data,
              lastRecordDate,
              icon,

          );
        },
      ).toList(),
    );
  }

  Widget _buildDataTrackingContainer(String name, String dataType, String data,
      String lastRecordDate, IconData icon) {
    return Container(
      //width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        //color: Colors.white,
       // border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataPhysicalTracking(
        agregar: () => _showAddDataSelect(context, name),
        icon: icon,
        name: name,
        dataType: dataType,
        data: data,
        lastRecordDate: lastRecordDate,
        coleccion: 'Registro-Corporal',
      ),
    );
  }

  String _getDataValue(String dato) {
    switch (dato) {
      case 'peso':
        return _peso.toString();
      case 'altura':
        return _altura.toString();
      case 'grasaCorporal':
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
      case 'grasaCorporal':
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
      case 'grasaCorporal':
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
      case 'grasaCorporal':
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
                  'Mis Registros Corporales',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
          CustomButton(
            text: 'Agregar',
            onPressed: () {
              _showAddData(context);
            },
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  void _showAddData(BuildContext context) {
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
          child: AddCorporalDataPage(),
        );
      },
    );
  }

  void _showAddDataSelect(BuildContext context, String data) {
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
          child: AddCorporalDataPage(
            selectedFieldType: data,
          ),
        );
      },
    );
  }
}
