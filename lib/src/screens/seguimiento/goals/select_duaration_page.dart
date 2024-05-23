import 'package:flutter/material.dart';
import 'package:gym_check/src/models/meta_diaria_model.dart';
import 'package:gym_check/src/models/meta_principal_model.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/goals_service.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:intl/intl.dart';

class SelectDuration extends StatefulWidget {
  final Map<String, Map<String, dynamic>> selectedGoals;
  final Map<String, dynamic> macros;
  final String goalType;

  SelectDuration({
    required this.selectedGoals,
    required this.macros,
    required this.goalType,
  });

  @override
  _SelectDurationState createState() => _SelectDurationState();
}

class _SelectDurationState extends State<SelectDuration> {
  late int _selectedDuration;
  late DateTime _startDate;
  late DateTime _endDate;
  final String _coleccion = 'Registro-Corporal';
  final Map<String, String> _datos = {
    'peso': 'Kilogramos:',
    'altura': 'Centimetros:',
  };
  late final Map<String, dynamic> datosCorporalesIniciales = {
    'peso': _peso,
    'altura': _altura,
  }; // Empty map initially

  double _peso = 0;
  double _altura = 0;

  @override
  void initState() {
    super.initState();
    _selectedDuration = 1;
    _startDate = DateTime.now();
    _endDate = _startDate.add(Duration(days: _selectedDuration));
    _loadUserDataLastDataPhysical();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Ultimos pasos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Meta Principal:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        widget.goalType,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tus macros:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                      //_showInfoDialog(context);
                    },
                  ),
                ],
              ),

               TrackingWidgets.buildLabelDetailsRow('Proteínas', '${widget.macros['proteinas']} g'),
               TrackingWidgets.buildLabelDetailsRow(
                  'Carbohidratos', '${widget.macros['carbohidratos']} g'),
              TrackingWidgets.buildLabelDetailsRow('Grasas', '${widget.macros['grasas']} g'),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Metas diarias seleccionadas:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.white),
                      onPressed: () {
                        //_showInfoDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildSelectedGoalsList(),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Tus datos corporales hasta ahora:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.white),
                      onPressed: () {
                        //_showInfoDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              TrackingWidgets.buildLabelDetailsRow('Peso', '$_peso kg'),
              TrackingWidgets.buildLabelDetailsRow('Altura', '$_altura cm'),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Seleccionar Duración:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                      //_showInfoDialog(context);
                    },
                  ),
                ],
              ),
              //const SizedBox(height: 8),
              _buildDurationSelector(),
              const SizedBox(height: 16),
              TrackingWidgets.buildLabelDetailsRow('Fecha de inicio:',
                  DateFormat('dd-MM-yyyy').format(_startDate)),
              TrackingWidgets.buildLabelDetailsRow('Fecha de finalización:',
                  DateFormat('dd-MM-yyyy').format(_endDate)),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Mostrar el diálogo de confirmación
                      bool confirmacion =
                          await mostrarDialogoConfirmacion(context);
                      if (confirmacion) {
                        // Mostrar el indicador de carga
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(), // Indicador de carga
                                  SizedBox(width: 20),
                                  Text('Creando meta...'),
                                ],
                              ),
                            );
                          },
                        );
                        // Crear la meta principal
                        // ignore: use_build_context_synchronously
                        await crearMetaPrincpal(context);
                        crearMetasDiarias(context, widget.selectedGoals);
                        // Ocultar el indicador de carga
                        Navigator.of(context).pop();

                         Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const PrincipalPage(
                          initialPageIndex: 2,
                        ),
                      ),
                    );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff0C1C2E),
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Crear metas'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 

  Widget _buildSelectedGoalsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.selectedGoals.entries.where((entry) {
        return entry.value['selected'] == true;
      }).map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 83, 83, 83),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                // Text('Selected: ${entry.value['selected']}'),
                // Text('Reminder Time: ${entry.value['reminderTime']}'),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Slider(
            activeColor: const Color.fromARGB(255, 25, 57, 94),
            value: _selectedDuration.toDouble(),
            min: 1,
            max: 6,
            divisions: 29,
            label: '$_selectedDuration Meses',
            onChanged: (value) {
              setState(() {
                _selectedDuration = value.toInt();
                _endDate =
                    _startDate.add(Duration(days: _selectedDuration * 30));
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '$_selectedDuration Meses',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<bool> mostrarDialogoConfirmacion(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible:
          false, // Impide que se cierre al tocar fuera de la ventana emergente
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que deseas crear esta meta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No confirmado
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmado
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadUserDataLastDataPhysical() async {
    try {
      //final globales = Provider.of<Globales>(context, listen: false);
      //Map<String, dynamic> userData = await UserService.getUserData(globales.idAuth);
      setState(() {
        //_nick = userData['nick'];
      });

      for (String dato in _datos.keys) {
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

  Future<void> crearMetaPrincpal(BuildContext context) async {
    String informacionMeta;
    String tipoRutina;

    // Completar la descripción de la meta y el tipo de rutina según el tipo de meta recibido
    switch (widget.goalType) {
      case 'Pérdida de peso':
        informacionMeta =
            'La pérdida de peso se centra en reducir la cantidad de grasa corporal y peso total para mejorar la salud y la apariencia física.';
        tipoRutina = 'perdida_peso';
        break;
      case 'Aumento de masa muscular':
        informacionMeta =
            'El aumento de masa muscular implica incrementar la cantidad de tejido muscular en el cuerpo para mejorar la fuerza y la apariencia física';
        tipoRutina = 'aumento_masa_muscular';
        break;
      case 'Definición muscular':
        informacionMeta =
            'La definición muscular implica reducir la grasa corporal para resaltar y definir los músculos, logrando una apariencia más marcada y tonificada';
        tipoRutina = 'definicion';
        break;
      case 'Mantener peso':
        informacionMeta =
            'Mantener peso implica mantener un equilibrio entre la ingesta y el gasto calórico para conservar un peso corporal estable a largo plazo';
        tipoRutina = 'mantener_peso';
        break;
      default:
        // Manejar un tipo de meta no reconocido
        informacionMeta = 'Descripción de la meta no especificada.';
        tipoRutina = 'Rutina no especificada';
    }

    MetaPrincipal meta = MetaPrincipal(
      tipo: "Principal",
      tipoMeta: widget.goalType,
      tipoRutina: tipoRutina,
      datosCorporalesIniciales: datosCorporalesIniciales,
      datosCorporalesFinales: datosCorporalesIniciales,
      datosCorporalesVariables: datosCorporalesIniciales,
      fechaInicio: _startDate,
      fechaFinalizacion: _endDate,
      finalizada: false,
      activa: true,
      duracion: _selectedDuration * 30,
      informacionMeta: informacionMeta,
      macros: widget.macros,
      metasDiarias: widget.selectedGoals,
    );

    await GoalsService.agregarMetaPrincipal(context, meta);
  }

  Future<void> crearMetasDiarias(BuildContext context,
    Map<String, Map<String, dynamic>> selectedGoals) async {
  try {
    DateTime now = DateTime.now();
    List<MetaDiaria> metasDiarias = [];

    selectedGoals.forEach((key, value) {
      bool selected = value['selected'] ?? false;
      DateTime reminderTime = value['reminderTime'] ?? now;
      double valor = (value['valor'] ?? 0.0).toDouble();

      MetaDiaria metaDiaria = MetaDiaria(
        tipo: 'Diaria',
        activaEnDia: true, // Inicia como activa
        seleccionada: selected,
        nombre: key,
        horaNotificacion: reminderTime,
        fechaCreacion: now,
        mensaje: key,
        valorMeta: valor, // Puedes establecer este valor según tu lógica
        valorActual: 0, // Puedes establecer este valor según tu lógica
        porcentajeCumplimiento:
            0.0, // Puedes establecer este valor según tu lógica
      );

      metasDiarias.add(metaDiaria);
    });

    // Crear un documento para todas las metas diarias
    Map<String, dynamic> metasDiariasData = {
      'tipo': 'Diaria',
      'fechaCreacion': now.toIso8601String(),
      'metas': metasDiarias.map((meta) => meta.toJson()).toList(),
    };

    // Llama al servicio para agregar las metas diarias a Firebase
    await GoalsService.agregarMetasDiarias(context, metasDiariasData);
  } catch (error) {
    // Manejo de errores
    print('Error al crear metas diarias: $error');
  }
}

}
