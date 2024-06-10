import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/food_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/corporal_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/force_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/workout_data_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhysicalTrackingPage extends StatefulWidget {
  final int? initialSubPageMenuIndex;

  const PhysicalTrackingPage({super.key, this.initialSubPageMenuIndex});

  @override
  // ignore: library_private_types_in_public_api
  _PhysicalTrackingPageState createState() => _PhysicalTrackingPageState();
}


class _PhysicalTrackingPageState extends State<PhysicalTrackingPage> {
  int _selectedMenuOption = 0;

  List<String> options = [
    'Rutinas',
    'Datos corporales',
    'Fuerza',
   // 'Consejos',
  ]; // Lista de opciones

  List<Color> highlightColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

   List<IconData> myIcons = [
    Icons.sports_gymnastics,
    Icons.accessibility,
    Icons.fitness_center,
    Icons.lightbulb_outline,
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption(); // Cargar el estado guardado de _selectedMenuOption
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable

    return SingleChildScrollView(
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1),
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Alinea los botones en el centro horizontal
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      icons: myIcons,
                     // highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionTrackingPhysical =
                              _selectedMenuOption;
                        });
                        await prefs.setInt(
                            'selectedMenuOptionTrackingPhysical', index);
                      },
                      selectedMenuOptionGlobal:
                          globalVariable.selectedMenuOptionTrackingPhysical,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _selectedMenuOption == 0
                ? const WorkOutDataPage()
                : const SizedBox(),
            _selectedMenuOption == 1
                ? const CorporalDataPage()
                : const SizedBox(),
            _selectedMenuOption == 2
                ? ForceDataPage()
                : const SizedBox(), // Si _selectedMenuOption no es 2, no mostrar el contenedor
            _selectedMenuOption == 3
                ? const SizedBox()
                : const SizedBox(), // Si _selectedMenuOption no es 3, no mostrar el contenedor
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = widget.initialSubPageMenuIndex ??
          prefs.getInt('selectedMenuOptionTrackingPhysical') ?? 0;
    });
  }
}