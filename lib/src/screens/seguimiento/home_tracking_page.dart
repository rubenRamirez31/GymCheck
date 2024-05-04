import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/goals/goals_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
// Importa otras páginas de seguimiento si es necesario

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTrackingPage extends StatefulWidget {
  const HomeTrackingPage({Key? key}) : super(key: key);

  @override
  _HomeTrackingPageState createState() => _HomeTrackingPageState();
}

class _HomeTrackingPageState extends State<HomeTrackingPage> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  int currentPageIndex = 0;
  List<String> options = [
    'Fisico',
    'Nutricional',
    'Emocional',
  ]; // Lista de opciones

   List<Color> highlightColors = [
    Colors.green, // Color de resaltado para 'Fisico'
    Colors.yellow, // Color de resaltado para 'Emocional'
    Colors.blue, // Color de resaltado para 'Nutricional'
  ];

  int _selectedMenuOption = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption();
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable =
        Provider.of<GlobalVariablesProvider>(context); // Obtiene la instancia de GlobalVariable

    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: Colors.indigo,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0C1C2E),
          title: const Text(
            'Seguimiento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.flag),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Color.fromARGB(255, 18, 18, 18),
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
                      heightFactor: 0.96,
                      child: GoalsPage(),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.health_and_safety),
              onPressed: () {
                // Acción para el botón de Salud
                  ReminderScheduler.scheduleReminders(context);
                print('Botón de Salud presionado debug para recordatorios');
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          
          child: Container(
             color: const Color.fromARGB(255, 18, 18, 18),
            child: Column(
              
              children: [
                SizedBox(height: 20, width: 10),
                Container(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     // crossAxisAlignment: CrossAxisAlignment.center,
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
                              globalVariable.selectedSubPageTracking =
                                  _selectedMenuOption;
                            });
                            await prefs.setInt('selectedMenuOption', index);
                          },
                          selectedMenuOptionGlobal:
                              globalVariable.selectedSubPageTracking ,
                        ),
                        // Aquí puedes agregar más elementos MenuButtonOption según sea necesario
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _selectedMenuOption == 0
                  ? const PhysicalTrackingPage()
                  : const SizedBox(), 
              _selectedMenuOption == 1
                  ? const SizedBox()
                  : const SizedBox(), 
              _selectedMenuOption == 2
                  ? const SizedBox()
                  : const SizedBox(), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = prefs.getInt('selectedMenuOption') ?? 0;
    });
  }

  Future<void> _handleRefresh() async {
    // Simula una operación de actualización
    await Future.delayed(const Duration(seconds: 1));

    // Reinicia la página
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PrincipalPage(
          initialPageIndex: 2,
        ),
      ),
    );
  }
}
