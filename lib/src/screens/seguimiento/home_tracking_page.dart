import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/alimentacion/create_alimento_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/create_workout_page.dart';
import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/physical-nutritional/month_view_widget.dart';
import 'package:gym_check/src/screens/seguimiento/productivity/daily_routine_page.dart';
import 'package:gym_check/src/screens/seguimiento/goals/goals_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/productivity_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_primary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_secundary_remider_page.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTrackingPage extends StatefulWidget {
  final Function? openDrawer;
  final int? initialPageIndex;
  final int? initialSubPageMenuIndex;
  const HomeTrackingPage(
      {Key? key,
      this.initialPageIndex,
      this.initialSubPageMenuIndex,
      this.openDrawer})
      : super(key: key);

  @override
  State<HomeTrackingPage> createState() => _HomeTrackingPageState();
}

class _HomeTrackingPageState extends State<HomeTrackingPage>
    with TickerProviderStateMixin {
  // int currentPageIndex = 0;
  List<String> options = [
    'Fisico',
    'Nutricional',
    //'Productividad', //Todos los recordatorios que se repiten se ven aqui
    //'Bienestar diario',
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
  late AnimationController _animationController;
  late Animation<double> _animation;

  int sisi = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption();
    _loadCalendarHeight();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  Future<void> _loadCalendarHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _containerHeight = prefs.getDouble('calendarHeight') ?? 300.0;
      _cellAspectRatio = _containerHeight == 300.0 ? 1 : 0.5;
      _isExpanded = _containerHeight == 450.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable
    final globales = context.watch<Globales>();

    print("globalVariable.selectedSubPageTracking");
    print(globalVariable.selectedSubPageTracking);
    print(_selectedMenuOption);
    print(_selectedMenuOption);
    print(_selectedMenuOption);
    print('_selectedMenuOptiondesdebuil');

    return Scaffold(
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
            icon: const Icon(Icons.add_alert),
            color: Colors.white,
            onPressed: () {
              _showOptionsBottomSheetRemider(context, DateTime.now());
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              _showOptionsBottomSheetRegister(context);
            },
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
                          //    highlightColors: highlightColors,
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
                          selectedMenuOptionGlobal: widget.initialPageIndex ??
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
                  ? PhysicalTrackingPage(
                      initialSubPageMenuIndex: widget.initialSubPageMenuIndex,
                    )
                  : const SizedBox(),
              _selectedMenuOption == 1
                  ? NutritionalTrackingPage(
                      initialSubPageMenuIndex: widget.initialSubPageMenuIndex)
                  : const SizedBox(),
              _selectedMenuOption == 2
                  ?  ProductivityTrackingPage(initialSubPageMenuIndex: widget.initialSubPageMenuIndex)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //  if(widget.initialPageIndex != null){

      _selectedMenuOption = widget.initialPageIndex ??
          prefs.getInt('selectedSubPageTracking') ??
          0;
      print("holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      print(_selectedMenuOption);

      //  }
      //  _selectedMenuOption = prefs.getInt('selectedSubPageTracking') ?? 0;
    });
  }

  void _toggleContainer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_isExpanded) {
        _containerHeight = 300.0;
        _cellAspectRatio = 1;
      } else {
        _containerHeight = 450.0;
        _cellAspectRatio = 0.5;
      }
      _isExpanded = !_isExpanded;
    });

    // Guarda el estado del tamaño del calendario en SharedPreferences
    await prefs.setDouble('calendarHeight', _containerHeight);
  }

  void _showOptionsBottomSheetRemider(
      BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recordar:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.add_alert, color: Colors.white),
                title:
                    Text('Recordatorio', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPrimaryReminderPage(
                              selectedDate: selectedDay,
                              tipo: "Recordatorio",
                            )),
                  );
                },
              ),
              ListTile(
                  leading: Icon(Icons.fitness_center, color: Colors.white),
                  title: Text('Rutina', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddSecondaryReminderPage(
                                selectedDate: selectedDay,
                                tipo: "Rutina",
                              )),
                    );
                  }),
              ListTile(
                leading: Icon(Icons.fastfood, color: Colors.white),
                title: Text('Comida',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Acción cuando se selecciona "Agregar Comida"
                  //Navigator.pop(context);
                  //_showOptionsBottomSheetRemiderNutricional(context);
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSecondaryReminderPage(
                              tipo: "Alimento",
                            )),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsBottomSheetRemiderNutricional(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.fastfood, color: Colors.white),
                title: Text('Agregar Comida',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSecondaryReminderPage(
                              tipo: "Alimento",
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.abc, color: Colors.white),
                title: Text('Agregar Suplemento',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSecondaryReminderPage(
                              tipo: "Suplemento",
                            )),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsBottomSheetRegister(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Registrar:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.accessibility, color: Colors.white),
                title: Text('Datos Corporales',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrincipalPage(
                              initialPageIndex: 2,
                              initialSubPageIndex: 0,
                              initialSubPageMenuIndex: 1,
                            )),
                  );
                },
              ),
              ListTile(
                  leading: Icon(Icons.fitness_center, color: Colors.white),
                  title: Text('Fuerza', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrincipalPage(
                                initialPageIndex: 2,
                                initialSubPageIndex: 0,
                                initialSubPageMenuIndex: 2,
                              )),
                    );
                  }),
              ListTile(
                leading: Icon(Icons.grain, color: Colors.white),
                title: Text('Macros', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrincipalPage(
                              initialPageIndex: 2,
                              initialSubPageIndex: 1,
                              initialSubPageMenuIndex: 1,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.local_drink, color: Colors.white),
                title: Text('Agua', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrincipalPage(
                              initialPageIndex: 2,
                              initialSubPageIndex: 1,
                              initialSubPageMenuIndex: 2,
                            )),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
