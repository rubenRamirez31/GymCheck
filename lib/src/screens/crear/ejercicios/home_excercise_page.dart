import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/crear/ejercicios/all_excercise_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/excercise_by_focus.dart';
import 'package:gym_check/src/screens/seguimiento/physical/corporal_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/workout_data_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeExercisePage extends StatefulWidget {
  const HomeExercisePage({Key? key}) : super(key: key);

  @override
  _HomeExercisePageState createState() => _HomeExercisePageState();
}

class _HomeExercisePageState extends State<HomeExercisePage> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  int _selectedMenuOption = 0;

  List<String> options = [
    'Todo',
    'Por enfoque muscular',
    'Por equipamiento',
  ]; // Lista de opciones

  List<Color> highlightColors = [
    Colors.green, // Color de resaltado para 'Fisico'
    Colors.green, // Color de resaltado para 'Fisico'
    Colors.green, // Color de resaltado para 'Fisico'
 
  ];

  @override
  void initState() {
    super.initState();
   // _loadSelectedMenuOption(); // Cargar el estado guardado de _selectedMenuOption
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable

    return SingleChildScrollView(
      child: Container(
         color: const Color.fromARGB(255, 18, 18, 18),
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            const SizedBox(height: 20),
            Container(
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
                      highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionHomeExercise =
                              _selectedMenuOption;
                        });
                        await prefs.setInt('selectedMenuOptionHomeExercise', index);
                      },
                      selectedMenuOptionGlobal: globalVariable.selectedMenuOptionHomeExercise,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _selectedMenuOption == 0
                ? const AllExercisePage(agregar: false,)
                : const SizedBox(),
            _selectedMenuOption == 1
                ? const ExerciseByFocusPage()
                : const SizedBox(),
            _selectedMenuOption == 2
                ? Container(
                    color:
                        const Color.fromARGB(255, 0, 0, 255), // Contenedor azul
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : const SizedBox(), // Si _selectedMenuOption no es 2, no mostrar el contenedor
            _selectedMenuOption == 4
                ? Container(
                    color: const Color.fromARGB(
                        255, 255, 255, 0), // Contenedor amarillo
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
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
      _selectedMenuOption = prefs.getInt('selectedMenuOptionHomeExercise') ?? 0;
    });
  }
}
