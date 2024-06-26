import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/seguimiento/productivity/daily_routine_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductivityTrackingPage extends StatefulWidget {
  final int? initialSubPageMenuIndex;

  const ProductivityTrackingPage({super.key, this.initialSubPageMenuIndex});

  @override
  // ignore: library_private_types_in_public_api
  _ProductivityTrackingPageState createState() => _ProductivityTrackingPageState();
}

class _ProductivityTrackingPageState extends State<ProductivityTrackingPage> {
  int _selectedMenuOption = 0;

  List<String> options = [
    'Rutina Semanal',
    'Pomodoro',
    //'Consejos',
  ]; // Lista de opciones

  List<IconData> myIcons = [
    Icons.calendar_view_week,
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
                          globalVariable.selectedMenuOptionTrackingProductivity =
                              _selectedMenuOption;
                        });
                        await prefs.setInt(
                            'selectedMenuOptionTrackingProductivity', index);
                      },
                      selectedMenuOptionGlobal: widget.initialSubPageMenuIndex ??
                          globalVariable.selectedMenuOptionTrackingProductivity,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _selectedMenuOption == 0
                ? const DailyRoutinePage()
                : const SizedBox(),
            _selectedMenuOption == 1
                ? const SizedBox()
                : const SizedBox(),
      
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
          prefs.getInt('selectedMenuOptionTrackingProductivity') ?? 0;
    });
  }
}
