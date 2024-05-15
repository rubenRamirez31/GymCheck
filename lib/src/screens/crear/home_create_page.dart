import 'package:circular_menu/circular_menu.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/alimentacion/create_alimento_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/all_excercise_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/home_excercise_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/all_workout_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/create_workout_page.dart';
import 'package:gym_check/src/screens/crear/series/all_series_page.dart';
import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/goals/goals_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/services/excercise_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCreatePage extends StatefulWidget {
  final Function? openDrawer;
  const HomeCreatePage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<HomeCreatePage> createState() => _HomeCreatePageState();
}

class _HomeCreatePageState extends State<HomeCreatePage>
    with TickerProviderStateMixin {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  int currentPageIndex = 0;
  List<String> options = [
    'Ejercicios',
    'Series',
    'Rutinas',
    'Alimientacion',
    //'Favoritos',
  ]; // Lista de opciones

  late Animation<double> _animation;
  late AnimationController _animationController;
  List<Color> highlightColors = [
    Colors.green, // Color de resaltado para 'Fisico'
    Colors.yellow, // Color de resaltado para 'Emocional'
    Colors.blue, // Color de resaltado para 'Nutricional'
    Colors.blue, // Color de resaltado para 'Nutricional'
    Colors.blue, // Color de resaltado para 'Nutricional'
  ];

  int _selectedMenuOption = 0;

  @override
  void initState() {
    // super.initState();
    _loadSelectedMenuOption();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
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
              'Creación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  agregarEjercicio();
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
                  const SizedBox(height: 20, width: 10),
                  Container(
                    color: const Color.fromARGB(255, 18, 18, 18),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          MenuButtonOption(
                            options: options,
                            highlightColors: highlightColors,
                            onItemSelected: (index) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                _selectedMenuOption = index;
                                globalVariable.selectedSubPageCreate =
                                    _selectedMenuOption;
                              });
                              await prefs.setInt(
                                  'selectedSubPageCreate', index);
                            },
                            selectedMenuOptionGlobal:
                                globalVariable.selectedSubPageCreate,
                          ),
                          // Puedes agregar más elementos MenuButtonOption según sea necesario
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _selectedMenuOption == 0
                      ? const AllExercisePage(agregar: false)
                      : const SizedBox(),
                  _selectedMenuOption == 1
                      ? const AllSeriePage(agregar: false)
                      : const SizedBox(),
                  _selectedMenuOption == 2
                      ? AllWorkoutPage()
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

          //Init Floating Action Bubble
          floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              // Floating action menu item
              Bubble(
                title: "Alimento",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.restaurant_menu,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {

                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateFoodPage(
                                    
                                  )),
                        );
                  _animationController.reverse();
                },
              ),
              // Floating action menu item
              Bubble(
                title: "Rutina",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.people,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrearWorkoutPage(
                                    
                                  )),
                        );
                  _animationController.reverse();
                },
              ),
              //Floating action menu item
              Bubble(
                title: "Serie",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.home,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrearSeriePage(
                                    
                                  )),
                        );
                  _animationController.reverse();
                },
              ),
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),

            // Floating Action button Icon color
            iconColor: Colors.white,

            // Flaoting Action button Icon
            iconData: Icons.add,
            backGroundColor: Colors.indigo,
          )),
    );
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // _selectedMenuOption = prefs.getInt('selectedSubPageCreate') ?? 0;
    });
  }

  Future<void> _handleRefresh() async {
    // Simula una operación de actualización
    await Future.delayed(const Duration(seconds: 1));

    // Reinicia la página
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const PrincipalPage(
          initialPageIndex: 1,
        ),
      ),
    );
  }

  Future<void> agregarEjercicio() async {
    try {
      //final exerciseCollectionRef = FirebaseFirestore.instance.collection('Ejercicios');

Exercise hipThrustExercise = Exercise(
  name: "Hip thrust",
  primaryFocus: "Glúteos",
  secondaryFocus: "Femoral",
  description: "El hip thrust es un ejercicio que se enfoca en fortalecer los glúteos y los músculos femorales. Se realiza acostado en el suelo con la espalda apoyada en un banco y las rodillas dobladas. Desde esta posición, se levantan las caderas hacia arriba hasta que el cuerpo esté en una línea recta desde las rodillas hasta los hombros.",
  representativeImageLink: "https://ejemplo.com/imagen_hip_thrust.png",
  videoLink: "https://ejemplo.com/video_hip_thrust.mp4",
  focusLevels: {'Glúteos': 3, 'Femoral': 2, 'Cuádriceps': 1},
  equipment: ['Banco', 'Barra', 'Discos de peso'],
  tags: ['Hip thrust', 'Glúteos', 'Femoral', 'Ejercicio de fuerza'],
);



      ExerciseService.agregarEjercicio(context, hipThrustExercise);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ejercicio agregado con éxito')),
      );
    } catch (error) {
      print('Error al agregar el ejercicio: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar el ejercicio')),
      );
    }
  }
}
