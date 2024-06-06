import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/crear/ejercicios/focus_on_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/corporal_data_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/workout_data_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseByFocusPage extends StatefulWidget {
  const ExerciseByFocusPage({Key? key}) : super(key: key);

  @override
  _ExerciseByFocusPageState createState() => _ExerciseByFocusPageState();
}

class _ExerciseByFocusPageState extends State<ExerciseByFocusPage> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  int _selectedMenuOption = 0;

  List<String> options = [
    'Pecho',
    'Pierna',
    'Espalda',
    'Espalda',
  ]; // List of options

  List<Color> highlightColors = [
    Colors.green, // Highlight color for 'All'
    Colors.green, // Highlight color for 'All'
    Colors.green, // Highlight color for 'All'
    Colors.green, // Highlight color for 'All'
 
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption(); // Load saved state of _selectedMenuOption
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Get the instance of GlobalVariable

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
                      .center, // Align buttons at the horizontal center
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionExerciseByFocus =
                              _selectedMenuOption;
                        });
                        await prefs.setInt(
                            'selectedMenuOptionExerciseByFocus', index);
                      },
                      selectedMenuOptionGlobal:
                          globalVariable.selectedMenuOptionExerciseByFocus,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _selectedMenuOption == 0
                ? const FocusedOnPage(muscle: "Pecho",)
                : const SizedBox(),
            _selectedMenuOption == 1
                ? const FocusedOnPage(muscle: "Pierna",)
                : const SizedBox(),
           
          ],
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption =
          prefs.getInt('selectedMenuOptionExerciseByFocus') ?? 0;
    });
  }
}
