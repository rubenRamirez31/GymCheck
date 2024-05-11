import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';

import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:intl/intl.dart';
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
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
    const Color.fromARGB(255, 94, 24, 246), // Color de resaltado para 'Fisico'
  ];
   bool _isLoading = false; // Variable para indicar si se están cargando las rutinas
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
      _isLoading = true; // Se inicia la carga, por lo que el indicador de carga será visible
    });

    try {
      final routines = await ReminderService.getFilteredPrimeReminders(
          context, "Rutina", _selectedMenuOption + 1);
      setState(() {
        _routines = routines;
        _isLoading = false; // Se ha completado la carga, por lo que se desactiva el indicador de carga
      });
    } catch (error) {
      print('Error al cargar las rutinas: $error');
    
    }
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(dateTimeString);
        String formattedDate = DateFormat('hh:mm a', 'es').format(dateTime);
        return formattedDate;
      } catch (error) {
        print('Error al formatear la fecha: $error');
      }
    }
    return 'Fecha no válida';
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                        options: options,
                        highlightColors: highlightColors,
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
        _selectedMenuOption == 0 ? _view() : const SizedBox(),
        _selectedMenuOption == 1 ? _view() : const SizedBox(),
        _selectedMenuOption == 2 ? _view() : const SizedBox(),
        _selectedMenuOption == 3 ? _view() : const SizedBox(),
        _selectedMenuOption == 4 ? _view() : const SizedBox(),
        _selectedMenuOption == 5 ? _view() : const SizedBox(),
        _selectedMenuOption == 6 ? _view() : const SizedBox(),

         CreateButton(
            text: 'Agregar',
            textColor: Colors.white,
            buttonColor: Colors.green,
            onPressed: () {
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
                  return const FractionallySizedBox(
                    heightFactor: 0.90,
                    child: AddReminderPage(
                      tipo: "Rutina",
                    ),
                  );
                },
              );
            },
            iconData: Icons.add,
            iconColor: Colors.white,
          ),
       
      ],
    );
  }

Widget _view() {
  print("hola $_selectedMenuOption");
  return SingleChildScrollView(
    child: _routines.isEmpty
        ? _isLoading
            ? Center(
                child: CircularProgressIndicator(), // Indicador de carga
              )
            : Container(
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
            _buildRoutineDetailsRowOnly("routineName"),
            SizedBox(height: 10, width: 10),
            _buildRoutineDetailsRow("Enfoque Principal:", "primaryFocus"),
            _buildRoutineDetailsRow("Enfoque Secundario:", "secondaryFocus"),
            
          ],
        ),)
        : Container(
            // width: screenSize.width,
            child: Column(
              children: _routines.map((routine) {
                return _buildRoutineContainer(
                  routine!['routineName'],
                  routine['primaryFocus'],
                  routine['secondaryFocus'],
                  routine['startTime'],
                  routine['endTime'],
                  routine['title'],
                  routine['description'],
                  routine['color'],
                  routine['id'],
                );
              }).toList(),
            ),
          ),
  );
}



  Widget _buildRoutineContainer(
    String routineName,
    String primaryFocus,
    String secondaryFocus,
    DateTime startTime,
    DateTime endTime,
    String title,
    String description,
    int color,
    String idRecordar,
  ) {
    return GestureDetector(
      onTap: () {
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
            _buildRoutineDetailsRowOnly(title),
            SizedBox(height: 10, width: 10),
            _buildRoutineDetailsRow("Enfoque Principal:", primaryFocus),
            _buildRoutineDetailsRow("Enfoque Secundario:", secondaryFocus),
            _buildRoutineDetailsRow(
                "Hora de inicio:", formatDateTime(startTime.toIso8601String())),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
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
              '$label',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineDetailsRowOnly(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineButtonWithIcon(
      String text, IconData icon, Function() onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }

  Widget _buildDataRow(String Nombre, String cantidad) {
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
              '$Nombre:',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              cantidad,
              style: const TextStyle(
                fontSize: 12,
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
}
