import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/goals/goals_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
// Importa otras páginas de seguimiento si es necesario

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTrackingPage extends StatefulWidget {
  final Function? openDrawer;
  const HomeTrackingPage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<HomeTrackingPage> createState() => _HomeTrackingPageState();
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
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable
    final globales = context.watch<Globales>();

    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: Colors.indigo,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              widget.openDrawer!();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(globales.fotoPerfil),
              ),
            ),
          ),
          backgroundColor: const Color(0xff0C1C2E),
          title: const Text(
            'Seguimiento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.flag),
              onPressed: () {
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
                      heightFactor: 0.96,
                      child: GoalsPage(),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.health_and_safety),
              onPressed: () {
                // Acción para el botón de Salud
                // ReminderScheduler.scheduleReminders(context);
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
                const SizedBox(height: 20, width: 10),
                Container(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding:  const EdgeInsets.symmetric(horizontal:50),
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
                              await prefs.setInt('selectedSubPageTracking', index);
                            },
                            selectedMenuOptionGlobal:
                                globalVariable.selectedSubPageTracking,
                          ),
                          // Aquí puedes agregar más elementos MenuButtonOption según sea necesario
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _selectedMenuOption == 0
                    ? const PhysicalTrackingPage()
                    : const SizedBox(),
                _selectedMenuOption == 1
                    ? const NutritionalTrackingPage()
                    : const SizedBox(),
                _selectedMenuOption == 2 ? const SizedBox() : const SizedBox(),
              ],
            ),
          ),
        ),
        floatingActionButton: CircularMenu(
          alignment: Alignment.bottomRight,
          toggleButtonColor: Colors.green, // Color del botón
          toggleButtonBoxShadow: [BoxShadow()],
          //toggleButtonAnimatedIconData: AnimatedIcons.menu_arrow,
          //toggleButtonMargin: 5.0, // Margen del botón
          //toggleButtonSize: 40.0, // Tamaño del botón

          items: [
            CircularMenuItem(
              icon: Icons.add, // Icono para agregar rutina
              color: Colors.blue, // Color del ícono
              boxShadow: [BoxShadow()],
              onTap: () {
                // Acción cuando se toca el ícono de agregar rutina
              },
            ),
            CircularMenuItem(
              icon: Icons.person, // Icono para registro corporal
              color: Colors.green, // Color del ícono
              boxShadow: [BoxShadow()],
              onTap: () {
                // Acción cuando se toca el ícono de registro corporal
              },
            ),
            CircularMenuItem(
              icon: Icons.fitness_center, // Icono para fuerza
              color: Colors.orange, // Color del ícono
              boxShadow: [BoxShadow()],
              onTap: () {
                // Acción cuando se toca el ícono de fuerza
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = prefs.getInt('selectedSubPageTracking') ?? 0;
    });
  }

  Future<void> _handleRefresh() async {
    // Simula una operación de actualización
    await Future.delayed(const Duration(seconds: 1));

    // Reinicia la página
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const PrincipalPage(
          initialPageIndex: 2,
        ),
      ),
    );
  }
}
