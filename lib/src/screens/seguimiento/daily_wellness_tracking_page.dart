import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyWellnessTrackingPage extends StatefulWidget {
  const DailyWellnessTrackingPage({Key? key}) : super(key: key);

  @override
  _DailyWellnessTrackingPageState createState() =>
      _DailyWellnessTrackingPageState();
}

class _DailyWellnessTrackingPageState extends State<DailyWellnessTrackingPage> {
  int _selectedMenuOption = 0;

  List<String> options = [
    'Productividad',
    'Emociones',
    'Enfoque',
    'Estres',
    'Consejos',
  ];

  List<Color> highlightColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  List<IconData> myIcons = [
    Icons.work,
    Icons.sentiment_satisfied,
    Icons.remove_red_eye,
    Icons.mood_bad,
    Icons.lightbulb_outline,
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption();
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
              padding: const EdgeInsets.symmetric(horizontal: 3),
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MenuButtonOption(
                      icons: myIcons,
                      options: options,
                     // highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionWellness = _selectedMenuOption;
                        });
                        await prefs.setInt(
                            'selectedMenuOptionWellness', index);
                      },
                      selectedMenuOptionGlobal: globalVariable.selectedMenuOptionWellness,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Add your widgets for each menu option here
          ],
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption =
          prefs.getInt('selectedMenuOptionWellness') ?? 0;
    });
  }
}
