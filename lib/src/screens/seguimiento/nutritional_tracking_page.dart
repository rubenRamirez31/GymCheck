import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/food_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/macros_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/water_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/corporal_data_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionalTrackingPage extends StatefulWidget {
   final int? initialSubPageMenuIndex;
  const NutritionalTrackingPage({Key? key, this.initialSubPageMenuIndex}) : super(key: key);

  @override
  _NutritionalTrackingPageState createState() => _NutritionalTrackingPageState();
}

class _NutritionalTrackingPageState extends State<NutritionalTrackingPage> {
  int _selectedMenuOption = 0;

  List<String> options = [
    'Alimentacion',
    'Macros',
    'Agua',
    //'Suplementos',
    //'Consejos',
  ]; // Lista de opciones

  List<Color> highlightColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,

  ];

     List<IconData> myIcons = [
    Icons.local_dining,
    Icons.grain,
    Icons.local_drink,
    Icons.local_pharmacy,
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
      child: Container(
        color: const Color.fromARGB(255, 18, 18, 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            const SizedBox(height: 5),
            Container(
               padding: EdgeInsets.symmetric(horizontal: 3),
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Alinea los botones en el centro horizontal
                  children: <Widget>[
                    MenuButtonOption(
                      icons: myIcons,
                      options: options,
                   //   highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionNutritional =
                              _selectedMenuOption;
                        });
                        await prefs.setInt('selectedMenuOptionNutritional', index);
                      },
                      selectedMenuOptionGlobal:
                          globalVariable.selectedMenuOptionNutritional,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _selectedMenuOption == 0
                ? const FoodDataPage()
                : const SizedBox(),
            _selectedMenuOption == 1
                ? const MacrosDataPage()
                : const SizedBox(),
            _selectedMenuOption == 2
                ? WaterDataPage()
                : const SizedBox(), // Si _selectedMenuOption no es 2, no mostrar el contenedor
            _selectedMenuOption == 4
                ? WaterDataPage()
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
      _selectedMenuOption = prefs.getInt('selectedMenuOptionNutritional') ?? 0;
    });
  }
}
