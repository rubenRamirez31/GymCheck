import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/seguimiento/daily_wellness_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/goals/goals_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTrackingPage extends StatefulWidget {
  final Function? openDrawer;
  const HomeTrackingPage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<HomeTrackingPage> createState() => _HomeTrackingPageState();
}

class _HomeTrackingPageState extends State<HomeTrackingPage> {
  int currentPageIndex = 0;
  List<String> options = [
    'Fisico',
    'Nutricional',
    'Bienestar diario',
  ]; // Lista de opciones

  List<Color> highlightColors = [
    Colors.white, // Color de resaltado para 'Fisico'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Nutricional'
  ];

  List<IconData> myIcons = [
    Icons.directions_run,
    Icons.local_dining,
    Icons.self_improvement,
  ];

  int _selectedMenuOption = 0;
  double _containerHeight = 300.0;
  double _cellAspectRatio = 1;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption();
    _loadCalendarHeight();
    currentPageIndex = 0;
  }

  Future<void> _loadCalendarHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _containerHeight = prefs.getDouble('calendarHeight') ?? 300.0;
      _cellAspectRatio = _containerHeight == 300.0 ? 1 : 0.5;
      _isExpanded = _containerHeight == 600.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable
    final globales = context.watch<Globales>();

    return GestureDetector(
      onTap: () {
        // Cierra el teclado si está abierto
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              widget.openDrawer!();
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
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
              color: Colors.white,
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
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 18, 18, 18),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
                        children: <Widget>[
                          MenuButtonOption(
                            options: options,
                            icons: myIcons,
                            highlightColors: highlightColors,
                            onItemSelected: (index) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                _selectedMenuOption = index;
                                globalVariable.selectedSubPageTracking =
                                    _selectedMenuOption;
                              });
                              await prefs.setInt(
                                  'selectedSubPageTracking', index);
                            },
                            selectedMenuOptionGlobal:
                                globalVariable.selectedSubPageTracking,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: _containerHeight,
                  curve: Curves.easeInOut,
                  child: Container(
                    height: _containerHeight,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MonthViewWidget(cellAspectRatio: _cellAspectRatio),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _toggleContainer();
                  },
                ),
                _selectedMenuOption == 0
                    ? const PhysicalTrackingPage()
                    : const SizedBox(),
                _selectedMenuOption == 1
                    ? const NutritionalTrackingPage()
                    : const SizedBox(),
                _selectedMenuOption == 2
                    ? const DailyWellnessTrackingPage()
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
      _selectedMenuOption = prefs.getInt('selectedSubPageTracking') ?? 0;
    });
  }

  void _toggleContainer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_isExpanded) {
        _containerHeight = 300.0;
        _cellAspectRatio = 1;
      } else {
        _containerHeight = 600.0;
        _cellAspectRatio = 0.5;
      }
      _isExpanded = !_isExpanded;
    });

    // Guarda el estado del tamaño del calendario en SharedPreferences
    await prefs.setDouble('calendarHeight', _containerHeight);
  }
}
