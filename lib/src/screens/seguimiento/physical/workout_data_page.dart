import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';

import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/tracking_funtions.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkOutDataPage extends StatefulWidget {
  const WorkOutDataPage({Key? key}) : super(key: key);

  @override
  State<WorkOutDataPage> createState() => _WorkOutDataPageState();
}

class _WorkOutDataPageState extends State<WorkOutDataPage> {
  int _selectedMenuOption = 0;
  List<Map<String, dynamic>?> _routines = [];
  List<String> options = [
    'L',
    'M',
    'Mi',
    'J',
    'V',
    'S',
    'D',
  ]; // Lista de opciones
  List<Color> highlightColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  bool _isLoading =
      false; // Variable para indicar si se están cargando las rutinas
  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption(); // Cargar el estado guardado de _selectedMenuOption
    _loadRoutines();
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedMenuOption = prefs.getInt('diaSeleccionado') ?? 0;
      });
      _loadRoutines();
    }
  }

  Future<void> _loadRoutines() async {
    setState(() {
      _isLoading =
          true; // Se inicia la carga, por lo que el indicador de carga será visible
    });

    try {
      final routines = await ReminderService.getFilteredPrimeReminders(
          context, "Rutina", _selectedMenuOption + 1);
      setState(() {
        _routines = routines;
        _isLoading =
            false; // Se ha completado la carga, por lo que se desactiva el indicador de carga
      });
    } catch (error) {
      print('Error al cargar las rutinas: $error');
    }
  }


String getDayByMenuOption() {
  switch (_selectedMenuOption) {
    case 0:
    case 0:
      return "Lunes";
    case 1:
      return "Martes";
    case 2:
      return "Miércoles";
    case 3:
      return "Jueves";
    case 4:
      return "Viernes";
    case 5:
      return "Sábado";
    case 6:
      return "Domingo";
    default:
      return "No";
  }
}


  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Mis Rutinas',
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
        Row(
          children: [
            Container(
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width - 20,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                        options: options,
                        // highlightColors: highlightColors,
                        //highlightColor: Colors.green,
                        onItemSelected: (index) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            _selectedMenuOption = index;
                            globalVariable.selectedMenuOptionDias =
                                _selectedMenuOption;
                          });
                          await prefs.setInt('diaSeleccionado', index);
                          // print(index);
                          _loadRoutines();
                        },
                        selectedMenuOptionGlobal:
                            globalVariable.selectedMenuOptionDias),
                    // Aquí puedes agregar más elementos MenuButtonOption según sea necesario
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _selectedMenuOption == 0 ? _view() : const SizedBox(),
        _selectedMenuOption == 1 ? _view() : const SizedBox(),
        _selectedMenuOption == 2 ? _view() : const SizedBox(),
        _selectedMenuOption == 3 ? _view() : const SizedBox(),
        _selectedMenuOption == 4 ? _view() : const SizedBox(),
        _selectedMenuOption == 5 ? _view() : const SizedBox(),
        _selectedMenuOption == 6 ? _view() : const SizedBox(),
         SizedBox(height: 50,)
       /* CustomButton(
          text: 'Agregar',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddSecondaryReminderPage(
                        tipo: "Rutina",
                      )),
            );
          },
          icon: Icons.add,
        ),*/
      ],
    );
  }

  Widget _view() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TrackingWidgets.buildLabelDetailsRowOnly(
              getDayByMenuOption(), MainAxisAlignment.center,  backColor: const Color.fromARGB(255, 53, 53, 53),
          textColor: Colors.white,),
        ),
        SingleChildScrollView(
          child: _routines.isEmpty
              ? _isLoading
                  ? Center(
                      child: CircularProgressIndicator(), // Indicador de carga
                    )
                  : Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TrackingWidgets.buildLabelDetailsRowOnly(
                                  "No hay rutinas", MainAxisAlignment.center),
                              SizedBox(height: 10, width: 10),
                               
                           
                            ],
                          ),
                        ),
                          SizedBox(height: 50,)
                    ],
                  )
              : Container(
                  // width: screenSize.width,
                  child: Column(
                    children: _routines.map((routine) {
                      return _buildRoutineContainer(
                          routine!['startTime'],
                          routine['endTime'],
                          routine['title'],
                          routine['description'],
                          routine['color'],
                          routine['id'],
                          routine['datosObjeto']);
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildRoutineContainer(
      DateTime startTime,
      DateTime endTime,
      String title,
      String description,
      int color,
      String idRecordar,
      Map<String, dynamic> datosRutina) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
              child: ViewReminder(
                reminderId: idRecordar,
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrackingWidgets.buildLabelDetailsRowOnly(
                title, MainAxisAlignment.center),
            SizedBox(height: 10, width: 10),
            TrackingWidgets.buildLabelDetailsRow(
                "Enfoque Principal:", datosRutina['primaryFocus']),
            TrackingWidgets.buildLabelDetailsRow(
                "Enfoque Secundario:", datosRutina['secondaryFocus']),
            TrackingWidgets.buildLabelDetailsRow("Hora de inicio:",
                TrackingFunctions.formatDateTime(startTime.toIso8601String())),
          ],
        ),
      ),
    );
  }
}
