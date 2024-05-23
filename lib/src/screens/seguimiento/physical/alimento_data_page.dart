import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';

import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDataPage extends StatefulWidget {
  const FoodDataPage({Key? key}) : super(key: key);

  @override
  State<FoodDataPage> createState() => _FoodDataPageState();
}

class _FoodDataPageState extends State<FoodDataPage> {
  int _selectedMenuOption = 0;
  List<Map<String, dynamic>?> _foods = [];
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
      false; // Variable para indicar si se están cargando los alimentos
  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption(); // Cargar el estado guardado de _selectedMenuOption
    _loadFoods();
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedMenuOption = prefs.getInt('diaSeleccionado') ?? 0;
      });
      _loadFoods();
    }
  }

  Future<void> _loadFoods() async {
    setState(() {
      _isLoading =
          true; // Se inicia la carga, por lo que el indicador de carga será visible
    });

    try {
      final foods = await ReminderService.getFilteredPrimeReminders(
          context, "Alimento", _selectedMenuOption + 1);
      setState(() {
        _foods = foods;
        _isLoading =
            false; // Se ha completado la carga, por lo que se desactiva el indicador de carga
      });
    } catch (error) {
      print('Error al cargar los alimentos: $error');
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
                'Mis Alimentos',
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
                          _loadFoods();
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
        CreateButton(
          text: 'Agregar',
          textColor: Colors.white,
          buttonColor: Colors.green,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddReminderPage(
                        tipo: "Alimento",
                      )),
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
      child: _foods.isEmpty
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
                      TrackingWidgets.buildLabelDetailsRowOnly(
                          "No hay alimentos", MainAxisAlignment.center),
                      SizedBox(height: 10, width: 10),
                      // _buildRoutineDetailsRow("Agrega rutinas:", "primaryFocus"),
                      // _buildRoutineDetailsRow("Enfoque Secundario:", "secondaryFocus"),
                    ],
                  ),
                )
          : Container(
              // width: screenSize.width,
              child: Column(
                children: _foods.map((food) {
                  return _buildFoodContainer(
                   
                    food!['startTime'],
                    food['endTime'],
                    food['title'],
                    food['description'],
                    food['color'],
                    food['id'],
                    food['datosAliemnto']
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildFoodContainer(
  
    DateTime startTime,
    DateTime endTime,
    String title,
    String description,
    int color,
    String idRecordar,
     Map<String, dynamic> datosAliemnto

  ) {

     
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor:   const Color.fromARGB(255, 18, 18, 18),
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
                "Proteinas:", datosAliemnto['Proteínas'].toString()),
            TrackingWidgets.buildLabelDetailsRow(
                "Grasas:", datosAliemnto['Grasas'].toString()),
            TrackingWidgets.buildLabelDetailsRow(
                "Carbos:", datosAliemnto['Carbos'].toString()),
           
            TrackingWidgets.buildLabelDetailsRow(
                "Hora de inicio:", formatDateTime(startTime.toIso8601String())),
          ],
        ),
      ),
    );
  }
}
