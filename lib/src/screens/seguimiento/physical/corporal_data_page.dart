import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/physical/add_corporal_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/calculate_corporal_data_page.dart';
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
  double _cintura = 0;
  double _cadera = 0;
  double _muslos = 0;
  double _brazos = 0;
  double _pecho = 0;

  String _fechaPeso = '';
  String _fechaAltura = '';
  String _fechaGrasa = '';
  String _fechaCintura = '';
  String _fechaCadera = '';
  String _fechaMuslos = '';
  String _fechaBrazos = '';
  String _fechaPecho = '';

  final String _coleccion = 'Registro-Corporal';
  final Map<String, String> _datos = {
    'peso': 'Kilogramos:',
    'altura': 'Centimetros:',
    'grasaCorporal': 'Porcentaje:',
    'circunferenciaCintura': 'Centimetros:',
    'circunferenciaCadera': 'Centimetros:',
    'circunferenciaMuslos': 'Centimetros:',
    'circunferenciaBrazos': 'Centimetros:',
    'circunferenciaPecho': 'Centimetros:',
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
            case 'circunferenciaCintura':
              _cintura = data['circunferenciaCintura'] ?? 0;
              _fechaCintura = data['fecha'] ?? '';
              break;
            case 'circunferenciaCadera':
              _cadera = data['circunferenciaCadera'] ?? 0;
              _fechaCadera = data['fecha'] ?? '';
              break;
            case 'circunferenciaMuslos':
              _muslos = data['circunferenciaMuslos'] ?? 0;
              _fechaMuslos = data['fecha'] ?? '';
              break;
            case 'circunferenciaBrazos':
              _brazos = data['circunferenciaBrazos'] ?? 0;
              _fechaBrazos = data['fecha'] ?? '';
              break;
            case 'circunferenciaPecho':
              _pecho = data['circunferenciaPecho'] ?? 0;
              _fechaPecho = data['fecha'] ?? '';
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
          String tipo = _getType(name);
          String nameView = _getDataName(name);
          String lastRecordDate = _getDataDate(name);
          IconData icon = _getIcon(name);

          if (lastRecordDate.isEmpty) {
            return const SizedBox();
          }

          return _buildDataTrackingContainer(
            nameView,
            dataType,
            data,
            lastRecordDate,
            icon,
            tipo
          );
        },
      ).toList(),
    );
  }

  Widget _buildDataTrackingContainer(String name, String dataType, String data,
      String lastRecordDate, IconData icon, String tipo) {
    return Container(
      decoration: BoxDecoration(
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
        tipo: tipo
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
      case 'circunferenciaCintura':
        return _cintura.toString();
      case 'circunferenciaCadera':
        return _cadera.toString();
      case 'circunferenciaMuslos':
        return _muslos.toString();
      case 'circunferenciaBrazos':
        return _brazos.toString();
      case 'circunferenciaPecho':
        return _pecho.toString();
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
      case 'circunferenciaCintura':
        return 'Circunferencia de Cintura';
      case 'circunferenciaCadera':
        return 'Circunferencia de Cadera';
      case 'circunferenciaMuslos':
        return 'Circunferencia de Muslos';
      case 'circunferenciaBrazos':
        return 'Circunferencia de Brazos';
      case 'circunferenciaPecho':
        return 'Circunferencia de Pecho';
      default:
        return '';
    }
  }
  String _getType(String dato) {
    switch (dato) {
      case 'peso':
        return "peso";
      case 'altura':
        return "altura";
      case 'grasaCorporal':
        return 'grasaCorporal';
      case 'circunferenciaCintura':
        return 'circunferenciaCintura';
      case 'circunferenciaCadera':
        return 'circunferenciaCadera';
      case 'circunferenciaMuslos':
        return 'circunferenciaMuslos';
      case 'circunferenciaBrazos':
        return 'circunferenciaBrazos';
      case 'circunferenciaPecho':
        return 'circunferenciaPecho';
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
      case 'circunferenciaCintura':
        return _fechaCintura;
      case 'circunferenciaCadera':
        return _fechaCadera;
      case 'circunferenciaMuslos':
        return _fechaMuslos;
      case 'circunferenciaBrazos':
        return _fechaBrazos;
      case 'circunferenciaPecho':
        return _fechaPecho;
      default:
        return '';
    }
  }

  IconData _getIcon(String dato) {
    switch (dato) {
      case 'peso':
        return Icons.monitor_weight;
      case 'altura':
        return Icons.height;
      case 'grasaCorporal':
        return Icons.fitness_center;
      case 'circunferenciaCintura':
      case 'circunferenciaCadera':
      case 'circunferenciaMuslos':
      case 'circunferenciaBrazos':
      case 'circunferenciaPecho':
        return Icons.straighten;
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
            text: 'Agregar nuevo dato',
            onPressed: () {
              _showAddData(context);
            },
            icon: Icons.add,
          ),
       /*   CustomButton(
            text: 'Calcular',
            onPressed: () {
              _showCalculateData(context);
            },
            icon: Icons.calculate,
          ),*/
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
  void _showCalculateData(BuildContext context) {
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
          child: CalculateCorporalDataPage(),
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
