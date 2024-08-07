import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_primary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_secundary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/tracking_funtions.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyRoutinePage extends StatefulWidget {
  const DailyRoutinePage({Key? key}) : super(key: key);

  @override
  State<DailyRoutinePage> createState() => _DailyRoutinePageState();
}

class _DailyRoutinePageState extends State<DailyRoutinePage> {
  int _selectedMenuOption = 0;
  List<Map<String, dynamic>?> _routines = [];
  List<String> options = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
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
        _selectedMenuOption = prefs.getInt('selectedDay') ?? 0;
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
          context, "Rutina", _selectedMenuOption + 1,
          tipoAdicional1: "Alimento", tipoAdicional2: "Recordatorio");
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
                'Mi rutina diaria',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  width: MediaQuery.of(context).size.width - 20,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        MenuButtonOption(
                            options: options,
                            //highlightColors: highlightColors,
                            onItemSelected: (index) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                _selectedMenuOption = index;
                                globalVariable.selectedMenuOptionDias =
                                    _selectedMenuOption;
                              });
                              await prefs.setInt('selectedDay', index);
                              _loadRoutines();
                            },
                            selectedMenuOptionGlobal:
                                globalVariable.selectedMenuOptionDias),
                      ],
                    ),
                  ),
                ),
              ],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Agregar',
              onPressed: () {
                _showOptionsBottomSheet(context, DateTime.now());
              },
              icon: Icons.timer_outlined,
            ),
          ],
        ),
        SizedBox(
          height: 100,
        )
      ],
    );
  }

  Widget _view() {
    return Column(
      children: [
        SingleChildScrollView(
          child: _routines.isEmpty
              ? _isLoading
                  ? Center(
                      child: Container(
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
                                "Cargando...", MainAxisAlignment.center),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ), // Indicador de carga
                          ],
                        ),
                      ),
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
                                  "Sin recordatorios",
                                  MainAxisAlignment.center),
                              SizedBox(height: 10, width: 10),
                            ],
                          ),
                        ),
                      ],
                    )
              : Container(
                  child: Column(
                    children: _routines.map((routine) {
                      return _buildRoutineContainer(
                          routine!['startTime'],
                          routine['endTime'],
                          routine['title'],
                          routine['description'],
                          routine['color'],
                          routine['id']);
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildRoutineContainer(DateTime startTime, DateTime endTime,
      String title, String description, int color, String idRecordar) {
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
            TrackingWidgets.buildLabelDetailsRow("Start Time:",
                TrackingFunctions.formatDateTime(startTime.toIso8601String())),
          ],
        ),
      ),
    );
  }

  Future _showOptionsBottomSheet(BuildContext context, DateTime selectedDay) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recordar:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.add_alert, color: Colors.white),
                title:
                    Text('Otra actividad o recordatorio', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPrimaryReminderPage(
                              selectedDate: selectedDay,
                              tipo: "Recordatorio",
                            )),
                  );
                },
              ),
              ListTile(
                  leading: Icon(Icons.fitness_center, color: Colors.white),
                  title: Text('Rutina', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddSecondaryReminderPage(
                                selectedDate: selectedDay,
                                tipo: "Rutina",
                              )),
                    );
                  }),
              ListTile(
                leading: Icon(Icons.fastfood, color: Colors.white),
                title: Text('Comida / Suplemento',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Acción cuando se selecciona "Agregar Comida"
                  //Navigator.pop(context);
                  _showOptionsBottomSheetNutricional(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsBottomSheetNutricional(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.fastfood, color: Colors.white),
                title: Text('Agregar Comida',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSecondaryReminderPage(
                              tipo: "Alimento",
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.abc, color: Colors.white),
                title: Text('Agregar Suplemento',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSecondaryReminderPage(
                              tipo: "Suplemento",
                            )),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
