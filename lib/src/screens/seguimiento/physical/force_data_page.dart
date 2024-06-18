import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/physical/add_force_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/data_physical_tracking_widget.dart';
import 'package:gym_check/src/services/physical_data_service.dart'; // Importa tu servicio

class ForceDataPage extends StatefulWidget {
  const ForceDataPage({Key? key}) : super(key: key);

  @override
  _ForceDataPageState createState() => _ForceDataPageState();
}

class _ForceDataPageState extends State<ForceDataPage> {
  List<Map<String, dynamic>> _forceData = []; // Lista para almacenar los datos de fuerza

  @override
  void initState() {
    super.initState();
    _loadUserDataLastDataForce();
  }

  Future<void> _loadUserDataLastDataForce() async {
    try {
      // Obtener los últimos datos de fuerza del usuario
      final latestData = await PhysicalDataService.getLatestPhysicalDataV2(context, 'Registro-Fuerza');
      setState(() {
        _forceData = latestData.values.toList().cast<Map<String, dynamic>>(); // Convertir la lista a tipo List<Map<String, dynamic>>
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
                  'Mis Registros de Fuerza',
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
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Aquí se construyen los contenedores de seguimiento de datos de fuerza
          Column(
            children: _forceData.map((data) {
              // Obtener los datos de fuerza
              final String nombre = data['ejercicio'] ?? '';
              final String equipamiento = data['equipamiento'] ?? '';
              const String conector = 'con';
              final String nombreContenedor = '$nombre $conector $equipamiento';

              final String fecha = data['fecha'] ?? '';
              final double valor = data['valor'] ?? 0.0; // Suponiendo que el valor se almacena en kilogramos
              final String tipo = data['tipo'] ?? ''; // Suponiendo que el valor se almacena en kilogramos
              // Construir y devolver el contenedor de seguimiento de datos
              return Container(
                //width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                 // color: Colors.white,
                  //border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataPhysicalTracking(
                   agregar: () => _showAddDataSelect(context, nombre, equipamiento),
                  icon: Icons.fitness_center, // Icono para todos los contenedores
                  name: nombreContenedor,
                  dataType: 'Kg', // Se muestra en todos los contenedores
                  data: '$valor', // Valor en kilogramos
                  lastRecordDate: fecha,
                  coleccion: 'Registro-Fuerza',
                  tipo: tipo,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Agregar nuevo ejercicio',
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
          child: AddForceDataPage(),
        );
      },
    );
  }
  void _showAddDataSelect(BuildContext context, String exercise, String equipament) {
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
          child: AddForceDataPage(exercise: exercise, equipament: equipament,),
        );
      },
    );
  }
}
