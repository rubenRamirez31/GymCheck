import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/alimentacion/all_alimento_page.dart';
import 'package:gym_check/src/screens/crear/alimentacion/create_alimento_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/all_excercise_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/all_workout_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/create_workout_page.dart';
import 'package:gym_check/src/screens/crear/series/all_series_page.dart';
import 'package:gym_check/src/screens/crear/series/create_serie_page.dart';
import 'package:gym_check/src/screens/principal.dart';
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
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
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

    return Scaffold(
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
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(
            context,
            MaterialPageRoute(
              //aqui deberia de viajar a la parte de seguimiento nutricional apra registrar macros
              builder: (context) => PrincipalPage(initialPageIndex: 2,initialSubPageIndex: 0, initialSubPageMenuIndex: 1,
             
              ),
            ),
          );
              },
              color: Colors.white,
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
                         // highlightColors: highlightColors,
                          onItemSelected: (index) async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              _selectedMenuOption = index;
                              globalVariable.selectedSubPageCreate =
                                  _selectedMenuOption;
                            });
                            await prefs.setInt('selectedSubPageCreate', index);
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
                    ? const AllWorkoutPage(
                        agregar: false,
                      )
                    : const SizedBox(),
                _selectedMenuOption == 3
                    ? const AllAlimentosPage(
                        agregar: false,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            Bubble(
              title: "Serie",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.playlist_add,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearSeriePage()),
                );
                _animationController.reverse();
              },
            ),

            Bubble(
              title: "Rutina",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.sports_gymnastics,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearWorkoutPage()),
                );
                _animationController.reverse();
              },
            ),
            //Floating action menu item

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
                  MaterialPageRoute(builder: (context) => CreateFoodPage()),
                );
                _animationController.reverse();
              },
            ),
            // Floating action menu item
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
        ));
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = prefs.getInt('selectedSubPageCreate') ?? 0;
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
      Exercise pressInclinadoExercise = Exercise(
        name: "Press inclinado",
        primaryFocus: "Pecho",
        secondaryFocus: "Tríceps",
        description:
            "El press inclinado es un ejercicio de levantamiento de peso que se realiza en un banco inclinado. Implica empujar una barra o mancuernas hacia arriba desde el pecho hasta que los brazos estén completamente extendidos, pero con un ángulo de inclinación del banco que pone más énfasis en la parte superior del pecho.",
        representativeImageLink:
            "https://ejemplo.com/imagen_press_inclinado.png",
        videoLink: "https://ejemplo.com/video_press_inclinado.mp4",
        focusLevels: {'Pecho': 3, 'Tríceps': 2, 'Hombro': 1},
        equipment: ['Barra', 'Mancuernas', 'Máquina Smith'],
        tags: [
          'Press inclinado',
          'Pecho',
          'Tríceps',
          'Ejercicio de levantamiento de pesas'
        ],
      );
      Exercise pressDeclinadoExercise = Exercise(
        name: "Press declinado",
        primaryFocus: "Pecho",
        secondaryFocus: "Tríceps",
        description:
            "El press declinado es un ejercicio de levantamiento de peso que se realiza en un banco declinado. Implica empujar una barra o mancuernas hacia arriba desde el pecho hasta que los brazos estén completamente extendidos, pero con un ángulo de declinación del banco que pone más énfasis en la parte inferior del pecho.",
        representativeImageLink:
            "https://ejemplo.com/imagen_press_declinado.png",
        videoLink: "https://ejemplo.com/video_press_declinado.mp4",
        focusLevels: {'Pecho': 3, 'Tríceps': 2, 'Hombro': 1},
        equipment: ['Barra', 'Mancuernas', 'Máquina Smith'],
        tags: [
          'Press declinado',
          'Pecho',
          'Tríceps',
          'Ejercicio de levantamiento de pesas'
        ],
      );

      Exercise pressPlanoExercise = Exercise(
        name: "Press plano",
        primaryFocus: "Pecho",
        secondaryFocus: "Tríceps",
        description:
            "El press plano es un ejercicio de levantamiento de peso que se realiza acostado en un banco horizontal. Implica empujar una barra o mancuernas hacia arriba desde el pecho hasta que los brazos estén completamente extendidos.",
        representativeImageLink: "https://ejemplo.com/imagen_press_plano.png",
        videoLink: "https://ejemplo.com/video_press_plano.mp4",
        focusLevels: {'Pecho': 3, 'Tríceps': 2, 'Hombro': 1},
        equipment: [
          'Barra',
          'Mancuernas',
          'Máquina Smith',
          'Máquina de press de pecho'
        ],
        tags: [
          'Press plano',
          'Pecho',
          'Tríceps',
          'Ejercicio de levantamiento de pesas'
        ],
      );

      Exercise fondosParalelasExercise = Exercise(
        name: "Fondos en paralelas",
        primaryFocus: "Pecho",
        secondaryFocus: "Tríceps",
        description:
            "Los fondos en paralelas son un ejercicio de calistenia que se realiza con el propio peso corporal. Implica colgarse de barras paralelas y bajar el cuerpo hacia abajo flexionando los codos, luego se empuja hacia arriba hasta que los brazos estén completamente extendidos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_fondos_paralelas.png",
        videoLink: "https://ejemplo.com/video_fondos_paralelas.mp4",
        focusLevels: {'Pecho': 3, 'Tríceps': 2, 'Hombro': 1},
        equipment: ['Barras paralelas'],
        tags: [
          'Fondos en paralelas',
          'Pecho',
          'Tríceps',
          'Ejercicio de calistenia'
        ],
      );

      Exercise aperturasMancuernasExercise = Exercise(
        name: "Aperturas con mancuernas",
        primaryFocus: "Pecho",
        secondaryFocus: "Deltoides",
        description:
            "Las aperturas con mancuernas son un ejercicio de aislamiento para el pecho. Se realizan acostado en un banco plano con una mancuerna en cada mano. Desde una posición extendida, se bajan las mancuernas hacia los lados hasta que los brazos estén paralelos al suelo y luego se llevan de vuelta a la posición inicial.",
        representativeImageLink:
            "https://ejemplo.com/imagen_aperturas_mancuernas.png",
        videoLink: "https://ejemplo.com/video_aperturas_mancuernas.mp4",
        focusLevels: {'Pecho': 3, 'Deltoides': 2, 'Tríceps': 1},
        equipment: ['Mancuernas', 'Banco plano'],
        tags: [
          'Aperturas con mancuernas',
          'Pecho',
          'Deltoides',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise pulloverMancuernaExercise = Exercise(
        name: "Pull-over con mancuerna",
        primaryFocus: "Pecho",
        secondaryFocus: "Espalda",
        description:
            "El pull-over con mancuerna es un ejercicio compuesto que trabaja principalmente el músculo pectoral y secundariamente la espalda. Se realiza acostado en un banco plano con una mancuerna sujetada con ambas manos sobre el pecho. Desde esta posición, se baja la mancuerna por detrás de la cabeza manteniendo los brazos ligeramente flexionados y luego se eleva de nuevo a la posición inicial.",
        representativeImageLink:
            "https://ejemplo.com/imagen_pullover_mancuerna.png",
        videoLink: "https://ejemplo.com/video_pullover_mancuerna.mp4",
        focusLevels: {'Pecho': 3, 'Espalda': 2, 'Tríceps': 1},
        equipment: ['Mancuerna', 'Banco plano'],
        tags: [
          'Pull-over con mancuerna',
          'Pecho',
          'Espalda',
          'Ejercicio compuesto'
        ],
      );

      Exercise flexionesExercise = Exercise(
        name: "Flexiones (push-ups)",
        primaryFocus: "Pecho",
        secondaryFocus: "Tríceps",
        description:
            "Las flexiones, también conocidas como push-ups, son un ejercicio básico de fuerza que se realiza con el propio peso corporal. Se realizan apoyando las manos y los pies en el suelo, manteniendo el cuerpo recto y bajando el pecho hacia el suelo flexionando los codos, luego se empuja hacia arriba hasta que los brazos estén completamente extendidos.",
        representativeImageLink: "https://ejemplo.com/imagen_flexiones.png",
        videoLink: "https://ejemplo.com/video_flexiones.mp4",
        focusLevels: {'Pecho': 3, 'Tríceps': 2, 'Hombro': 1},
        equipment: [],
        tags: [
          'Flexiones',
          'Push-ups',
          'Pecho',
          'Tríceps',
          'Ejercicio de peso corporal'
        ],
      );

      Exercise crucesPoleaAltaExercise = Exercise(
        name: "Cruces en polea alta",
        primaryFocus: "Pecho",
        secondaryFocus: "Deltoides",
        description:
            "Los cruces en polea alta son un ejercicio de aislamiento para el pecho. Se realiza con una polea alta y un aparato de polea ajustable con dos mangos. Se coloca un pie adelante del otro y se jalan los mangos hacia abajo y hacia el frente cruzándolos frente al cuerpo hasta que los brazos estén extendidos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_cruces_polea_alta.png",
        videoLink: "https://ejemplo.com/video_cruces_polea_alta.mp4",
        focusLevels: {'Pecho': 3, 'Deltoides': 2, 'Tríceps': 1},
        equipment: ['Aparato de polea alta'],
        tags: [
          'Cruces en polea alta',
          'Pecho',
          'Deltoides',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise crucesPoleaMediaExercise = Exercise(
        name: "Cruces en polea media",
        primaryFocus: "Pecho",
        secondaryFocus: "Deltoides",
        description:
            "Los cruces en polea media son un ejercicio de aislamiento para el pecho. Se realiza con una polea ajustada a una posición media y un aparato de polea con dos mangos. Se coloca un pie adelante del otro y se jalan los mangos hacia abajo y hacia el frente cruzándolos frente al cuerpo hasta que los brazos estén extendidos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_cruces_polea_media.png",
        videoLink: "https://ejemplo.com/video_cruces_polea_media.mp4",
        focusLevels: {'Pecho': 3, 'Deltoides': 2, 'Tríceps': 1},
        equipment: ['Aparato de polea con polea ajustada a posición media'],
        tags: [
          'Cruces en polea media',
          'Pecho',
          'Deltoides',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise crucesPoleaBajaExercise = Exercise(
        name: "Cruces en polea baja",
        primaryFocus: "Pecho",
        secondaryFocus: "Deltoides",
        description:
            "Los cruces en polea baja son un ejercicio de aislamiento para el pecho. Se realiza con una polea baja y un aparato de polea con dos mangos. Se coloca un pie adelante del otro y se jalan los mangos hacia arriba y hacia el frente cruzándolos frente al cuerpo hasta que los brazos estén extendidos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_cruces_polea_baja.png",
        videoLink: "https://ejemplo.com/video_cruces_polea_baja.mp4",
        focusLevels: {'Pecho': 3, 'Deltoides': 2, 'Tríceps': 1},
        equipment: ['Aparato de polea con polea ajustada a posición baja'],
        tags: [
          'Cruces en polea baja',
          'Pecho',
          'Deltoides',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise pulloverMaquinaExercise = Exercise(
        name: "Pullover en máquina",
        primaryFocus: "Pecho",
        secondaryFocus: "Espalda",
        description:
            "El pullover en máquina es un ejercicio que trabaja principalmente el músculo pectoral y secundariamente la espalda. Se realiza en una máquina diseñada específicamente para el ejercicio. Se sujeta el agarre o las asas de la máquina con ambas manos y se baja el brazo hacia atrás, manteniendo una ligera flexión en los codos y luego se lleva el brazo de vuelta a la posición inicial.",
        representativeImageLink:
            "https://ejemplo.com/imagen_pullover_maquina.png",
        videoLink: "https://ejemplo.com/video_pullover_maquina.mp4",
        focusLevels: {'Pecho': 3, 'Espalda': 2, 'Tríceps': 1},
        equipment: ['Máquina de pullover'],
        tags: [
          'Pullover en máquina',
          'Pecho',
          'Espalda',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise remoSentadoPoleaExercise = Exercise(
        name: "Remo sentado con polea",
        primaryFocus: "Espalda",
        secondaryFocus: "Bíceps",
        description:
            "El remo sentado con polea es un ejercicio de fuerza que trabaja principalmente los músculos de la espalda y secundariamente los bíceps. Se realiza sentado en un banco con los pies apoyados en la plataforma y se jala la barra hacia el abdomen manteniendo la espalda recta y los codos cerca del cuerpo.",
        representativeImageLink:
            "https://ejemplo.com/imagen_remo_sentado_polea.png",
        videoLink: "https://ejemplo.com/video_remo_sentado_polea.mp4",
        focusLevels: {'Espalda': 3, 'Bíceps': 2, 'Hombro': 1},
        equipment: ['Máquina de polea'],
        tags: [
          'Remo sentado con polea',
          'Espalda',
          'Bíceps',
          'Ejercicio de fuerza'
        ],
      );

      Exercise hipThrustExercise = Exercise(
        name: "Hip thrust",
        primaryFocus: "Glúteos",
        secondaryFocus: "Femoral",
        description:
            "El hip thrust es un ejercicio que se enfoca en fortalecer los glúteos y los músculos femorales. Se realiza acostado en el suelo con la espalda apoyada en un banco y las rodillas dobladas. Desde esta posición, se levantan las caderas hacia arriba hasta que el cuerpo esté en una línea recta desde las rodillas hasta los hombros.",
        representativeImageLink: "https://ejemplo.com/imagen_hip_thrust.png",
        videoLink: "https://ejemplo.com/video_hip_thrust.mp4",
        focusLevels: {'Glúteos': 3, 'Femoral': 2, 'Cuádriceps': 1},
        equipment: ['Banco', 'Barra', 'Discos de peso'],
        tags: ['Hip thrust', 'Glúteos', 'Femoral', 'Ejercicio de fuerza'],
      );

      Exercise remoBarraExercise = Exercise(
        name: "Remo con barra",
        primaryFocus: "Espalda",
        secondaryFocus: "Bíceps",
        description:
            "El remo con barra es un ejercicio compuesto que se enfoca en desarrollar la espalda y los bíceps. Se realiza de pie con las rodillas ligeramente flexionadas y la espalda recta. Se agarra una barra con las manos separadas al ancho de los hombros y se jala la barra hacia arriba hacia el abdomen, manteniendo los codos cerca del cuerpo.",
        representativeImageLink: "https://ejemplo.com/imagen_remo_barra.png",
        videoLink: "https://ejemplo.com/video_remo_barra.mp4",
        focusLevels: {'Espalda': 3, 'Bíceps': 2, 'Trapecio': 1},
        equipment: ['Barra', 'Discos de peso'],
        tags: ['Remo con barra', 'Espalda', 'Bíceps', 'Ejercicio compuesto'],
      );

      Exercise pesoMuertoExercise = Exercise(
        name: "Peso muerto",
        primaryFocus: "Espalda baja",
        secondaryFocus: "Femoral",
        description:
            "El peso muerto es uno de los ejercicios más efectivos para trabajar la espalda baja, los glúteos, los femorales y los músculos de la cadena posterior. Se realiza levantando una barra desde el suelo hasta la cadera, manteniendo la espalda recta y los hombros hacia atrás, y luego bajando la barra controladamente hasta el suelo.",
        representativeImageLink: "https://ejemplo.com/imagen_peso_muerto.png",
        videoLink: "https://ejemplo.com/video_peso_muerto.mp4",
        focusLevels: {'Espalda baja': 3, 'Femoral': 2, 'Glúteos': 1},
        equipment: ['Barra', 'Discos de peso'],
        tags: ['Peso muerto', 'Espalda baja', 'Femoral', 'Ejercicio compuesto'],
      );

      Exercise pulldownPoleaAltaExercise = Exercise(
        name: "Pull-down en polea alta",
        primaryFocus: "Espalda",
        secondaryFocus: "Bíceps",
        description:
            "El pull-down en polea alta es un ejercicio excelente para desarrollar la fuerza y el tamaño de la espalda, así como los músculos del brazo. Se realiza sentado en una máquina de polea alta con las rodillas debajo de las almohadillas y se jala la barra hacia abajo hacia el pecho, manteniendo la espalda recta y los codos cerca del cuerpo.",
        representativeImageLink:
            "https://ejemplo.com/imagen_pulldown_polea_alta.png",
        videoLink: "https://ejemplo.com/video_pulldown_polea_alta.mp4",
        focusLevels: {'Espalda': 3, 'Bíceps': 2, 'Trapecio': 1},
        equipment: ['Máquina de polea alta'],
        tags: [
          'Pull-down en polea alta',
          'Espalda',
          'Bíceps',
          'Ejercicio de fuerza'
        ],
      );
      Exercise remoPoleaSentadoExercise = Exercise(
        name: "Remo en polea sentado",
        primaryFocus: "Espalda",
        secondaryFocus: "Bíceps",
        description:
            "El remo en polea sentado es un ejercicio efectivo para desarrollar la fuerza y el tamaño de la espalda, así como los músculos del brazo. Se realiza sentado en una máquina de polea con las piernas debajo de las almohadillas y se jala la barra hacia el abdomen, manteniendo la espalda recta y los codos cerca del cuerpo.",
        representativeImageLink:
            "https://ejemplo.com/imagen_remo_polea_sentado.png",
        videoLink: "https://ejemplo.com/video_remo_polea_sentado.mp4",
        focusLevels: {'Espalda': 3, 'Bíceps': 2, 'Trapecio': 1},
        equipment: ['Máquina de polea'],
        tags: [
          'Remo en polea sentado',
          'Espalda',
          'Bíceps',
          'Ejercicio de fuerza'
        ],
      );

      Exercise pressMilitarExercise = Exercise(
        name: "Press militar",
        primaryFocus: "Hombros",
        secondaryFocus: "Tríceps",
        description:
            "El press militar es un ejercicio compuesto que se centra en desarrollar los músculos del hombro y los tríceps. Se realiza de pie o sentado, levantando una barra desde la parte superior del pecho hasta arriba de la cabeza, manteniendo los codos debajo de la barra en todo momento.",
        representativeImageLink: "https://ejemplo.com/imagen_press_militar.png",
        videoLink: "https://ejemplo.com/video_press_militar.mp4",
        focusLevels: {'Hombros': 3, 'Tríceps': 2, 'Trapecio': 1},
        equipment: ['Barra', 'Discos de peso'],
        tags: ['Press militar', 'Hombros', 'Tríceps', 'Ejercicio compuesto'],
      );

      Exercise elevacionesLateralesMancuernasExercise = Exercise(
        name: "Elevaciones laterales con mancuernas",
        primaryFocus: "Hombros",
        secondaryFocus: "Trapecio",
        description:
            "Las elevaciones laterales con mancuernas son un ejercicio de aislamiento que se centra en trabajar los músculos deltoides laterales, que son parte de los hombros. Se realizan de pie, sosteniendo una mancuerna en cada mano y levantando los brazos hacia los lados hasta que estén paralelos al suelo, manteniendo una ligera flexión en los codos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevaciones_laterales_mancuernas.png",
        videoLink:
            "https://ejemplo.com/video_elevaciones_laterales_mancuernas.mp4",
        focusLevels: {'Hombros': 3, 'Trapecio': 2, 'Deltoides posterior': 1},
        equipment: ['Mancuernas'],
        tags: [
          'Elevaciones laterales con mancuernas',
          'Hombros',
          'Trapecio',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise elevacionesFrontalesExercise = Exercise(
        name: "Elevaciones frontales",
        primaryFocus: "Hombros",
        secondaryFocus: "Deltoides anterior",
        description:
            "Las elevaciones frontales son un ejercicio que se centra en desarrollar los músculos del hombro, especialmente el deltoides anterior. Se pueden realizar con una barra o con mancuernas. Consiste en levantar los brazos hacia adelante desde los costados hasta que estén paralelos al suelo, manteniendo una ligera flexión en los codos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevaciones_frontales.png",
        videoLink: "https://ejemplo.com/video_elevaciones_frontales.mp4",
        focusLevels: {'Hombros': 3, 'Deltoides anterior': 2, 'Trapecio': 1},
        equipment: ['Barra', 'Mancuernas'],
        tags: [
          'Elevaciones frontales',
          'Hombros',
          'Deltoides anterior',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise facePullsExercise = Exercise(
        name: "Face pulls",
        primaryFocus: "Deltoides posterior",
        secondaryFocus: "Trapecio",
        description:
            "Los face pulls son un excelente ejercicio para trabajar los músculos del hombro, especialmente el deltoides posterior, así como el trapecio. Se realiza con una polea ajustada a la altura del rostro y se jala la cuerda hacia la cara, manteniendo los codos elevados y separados y los omóplatos retraídos.",
        representativeImageLink: "https://ejemplo.com/imagen_face_pulls.png",
        videoLink: "https://ejemplo.com/video_face_pulls.mp4",
        focusLevels: {'Deltoides posterior': 3, 'Trapecio': 2, 'Hombros': 1},
        equipment: ['Cuerda de polea'],
        tags: [
          'Face pulls',
          'Deltoides posterior',
          'Trapecio',
          'Ejercicio de aislamiento'
        ],
      );
      Exercise curl21sExercise = Exercise(
        name: "Curl 21s",
        primaryFocus: "Bíceps",
        secondaryFocus: "Antebrazo",
        description:
            "El Curl 21s es un ejercicio de bíceps que se divide en tres partes para trabajar diferentes partes del rango de movimiento. Se realiza con una barra o mancuernas. En la primera parte, se hacen 7 repeticiones desde una posición extendida hasta la mitad del rango. En la segunda parte, se hacen 7 repeticiones desde la mitad del rango hasta la contracción completa. Y en la tercera parte, se hacen 7 repeticiones completas desde la posición extendida hasta la contracción completa.",
        representativeImageLink: "https://ejemplo.com/imagen_curl_21s.png",
        videoLink: "https://ejemplo.com/video_curl_21s.mp4",
        focusLevels: {'Bíceps': 3, 'Antebrazo': 2, 'Hombros': 1},
        equipment: ['Barra', 'Mancuernas'],
        tags: ['Curl 21s', 'Bíceps', 'Antebrazo', 'Ejercicio de aislamiento'],
      );

      Exercise curlPredicadorExercise = Exercise(
        name: "Curl de predicador",
        primaryFocus: "Bíceps",
        secondaryFocus: "Antebrazo",
        description:
            "El curl de predicador es un ejercicio de aislamiento que se centra en trabajar los músculos del bíceps. Se realiza en un banco de predicador, con los brazos apoyados sobre el cojín inclinado y las manos sosteniendo una barra o mancuerna. Se flexionan los codos para levantar el peso hacia los hombros, manteniendo los brazos apoyados sobre el banco en todo momento.",
        representativeImageLink:
            "https://ejemplo.com/imagen_curl_predicador.png",
        videoLink: "https://ejemplo.com/video_curl_predicador.mp4",
        focusLevels: {'Bíceps': 3, 'Antebrazo': 2, 'Hombros': 1},
        equipment: ['Banco de predicador', 'Barra', 'Mancuernas'],
        tags: [
          'Curl de predicador',
          'Bíceps',
          'Antebrazo',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise curlMartilloMancuernasExercise = Exercise(
        name: "Curl de martillo con mancuernas",
        primaryFocus: "Bíceps",
        secondaryFocus: "Antebrazo",
        description:
            "El curl de martillo con mancuernas es un ejercicio que se enfoca en desarrollar los músculos del bíceps y los antebrazos. Se realiza de pie, sosteniendo una mancuerna en cada mano con las palmas mirándose entre sí. Se flexionan los codos para levantar las mancuernas hacia los hombros, manteniendo las muñecas en posición neutra durante todo el movimiento.",
        representativeImageLink:
            "https://ejemplo.com/imagen_curl_martillo_mancuernas.png",
        videoLink: "https://ejemplo.com/video_curl_martillo_mancuernas.mp4",
        focusLevels: {'Bíceps': 3, 'Antebrazo': 2, 'Hombros': 1},
        equipment: ['Mancuernas'],
        tags: [
          'Curl de martillo con mancuernas',
          'Bíceps',
          'Antebrazo',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise pressFrancesExercise = Exercise(
        name: "Press francés",
        primaryFocus: "Tríceps",
        secondaryFocus: "Hombros",
        description:
            "El press francés, también conocido como press de banca con agarre cerrado, es un ejercicio efectivo para trabajar los músculos del tríceps. Se realiza acostado en un banco con una barra o mancuernas sostenidas directamente sobre el pecho y los codos doblados. Luego, se extienden los brazos para levantar el peso hacia arriba, manteniendo los codos cerca de la cabeza.",
        representativeImageLink: "https://ejemplo.com/imagen_press_frances.png",
        videoLink: "https://ejemplo.com/video_press_frances.mp4",
        focusLevels: {'Tríceps': 3, 'Hombros': 2, 'Pecho': 1},
        equipment: ['Barra', 'Mancuernas'],
        tags: ['Press francés', 'Tríceps', 'Hombros', 'Ejercicio compuesto'],
      );

      Exercise extensionesPoleaAltaTricepsExercise = Exercise(
        name: "Extensiones de tríceps en polea alta",
        primaryFocus: "Tríceps",
        secondaryFocus: "Hombros",
        description:
            "Las extensiones de tríceps en polea alta son un ejercicio excelente para aislar y trabajar los músculos del tríceps. Se realiza de pie frente a una polea alta con una cuerda o barra, y se jala la cuerda hacia abajo extendiendo los brazos hacia abajo hasta que estén rectos, manteniendo los codos fijos cerca del cuerpo.",
        representativeImageLink:
            "https://ejemplo.com/imagen_extensiones_polea_alta_triceps.png",
        videoLink:
            "https://ejemplo.com/video_extensiones_polea_alta_triceps.mp4",
        focusLevels: {'Tríceps': 3, 'Hombros': 2, 'Pecho': 1},
        equipment: ['Cuerda de polea alta', 'Barra de polea alta'],
        tags: [
          'Extensiones de tríceps en polea alta',
          'Tríceps',
          'Hombros',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise pressTricepsBarraRectaExercise = Exercise(
        name: "Press de tríceps con barra recta",
        primaryFocus: "Tríceps",
        secondaryFocus: "Pecho",
        description:
            "El press de tríceps con barra recta es un ejercicio efectivo para desarrollar los músculos del tríceps, así como también involucra el pecho en menor medida. Se realiza acostado en un banco plano, sosteniendo una barra recta con las manos separadas a una distancia ligeramente más estrecha que el ancho de los hombros. Se baja la barra hacia la frente flexionando los codos y luego se extienden los brazos para levantarla de nuevo a la posición inicial.",
        representativeImageLink:
            "https://ejemplo.com/imagen_press_triceps_barra_recta.png",
        videoLink: "https://ejemplo.com/video_press_triceps_barra_recta.mp4",
        focusLevels: {'Tríceps': 3, 'Pecho': 2, 'Hombros': 1},
        equipment: ['Barra recta', 'Banco plano'],
        tags: [
          'Press de tríceps con barra recta',
          'Tríceps',
          'Pecho',
          'Ejercicio compuesto'
        ],
      );

      Exercise curlMunecaBarraExercise = Exercise(
        name: "Curl de muñeca con barra",
        primaryFocus: "Antebrazo",
        secondaryFocus: "Bíceps",
        description:
            "El curl de muñeca con barra es un ejercicio que se centra en fortalecer los músculos del antebrazo, específicamente los flexores de la muñeca. Se realiza de pie, sosteniendo una barra con un agarre supino y dejando que la barra cuelgue frente al cuerpo. Luego, se flexionan las muñecas para levantar la barra hacia arriba y luego se baja controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_curl_muñeca_barra.png",
        videoLink: "https://ejemplo.com/video_curl_muñeca_barra.mp4",
        focusLevels: {'Antebrazo': 3, 'Bíceps': 2, 'Hombros': 1},
        equipment: ['Barra recta'],
        tags: [
          'Curl de muñeca con barra',
          'Antebrazo',
          'Bíceps',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise curlMunecaMancuernaExercise = Exercise(
        name: "Curl de muñeca con mancuerna",
        primaryFocus: "Antebrazo",
        secondaryFocus: "Bíceps",
        description:
            "El curl de muñeca con mancuerna es un ejercicio que se enfoca en fortalecer los músculos del antebrazo, específicamente los flexores de la muñeca. Se realiza de pie, sosteniendo una mancuerna en una mano con un agarre supino y dejando que la mancuerna cuelgue frente al cuerpo. Luego, se flexionan las muñecas para levantar la mancuerna hacia arriba y luego se baja controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_curl_muñeca_mancuerna.png",
        videoLink: "https://ejemplo.com/video_curl_muñeca_mancuerna.mp4",
        focusLevels: {'Antebrazo': 3, 'Bíceps': 2, 'Hombros': 1},
        equipment: ['Mancuerna'],
        tags: [
          'Curl de muñeca con mancuerna',
          'Antebrazo',
          'Bíceps',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise reverseCurlMancuernaExercise = Exercise(
        name: "Reverse curl con mancuerna",
        primaryFocus: "Antebrazo",
        secondaryFocus: "Bíceps",
        description:
            "El reverse curl con mancuerna es un ejercicio que se centra en fortalecer los músculos del antebrazo, especialmente los extensores de la muñeca y los músculos del bíceps. Se realiza de pie, sosteniendo una mancuerna en cada mano con un agarre pronado (palmas hacia abajo). Se flexionan los codos para levantar las mancuernas hacia los hombros, manteniendo los brazos pegados al cuerpo.",
        representativeImageLink:
            "https://ejemplo.com/imagen_reverse_curl_mancuerna.png",
        videoLink: "https://ejemplo.com/video_reverse_curl_mancuerna.mp4",
        focusLevels: {'Antebrazo': 3, 'Bíceps': 2, 'Hombros': 1},
        equipment: ['Mancuernas'],
        tags: [
          'Reverse curl con mancuerna',
          'Antebrazo',
          'Bíceps',
          'Ejercicio de aislamiento'
        ],
      );

// Elevación de muñeca en pronación con barra
      Exercise elevacionMunecaPronacionBarraExercise = Exercise(
        name: "Elevación de muñeca en pronación con barra",
        primaryFocus: "Antebrazo",
        secondaryFocus: "Bíceps",
        description:
            "La elevación de muñeca en pronación con barra es un ejercicio que se centra en fortalecer los músculos del antebrazo, especialmente los flexores de la muñeca y los músculos del bíceps. Se realiza de pie, sosteniendo una barra con un agarre pronado (palmas hacia abajo). Se elevan las muñecas hacia arriba y luego se bajan controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_muñeca_pronacion_barra.png",
        videoLink:
            "https://ejemplo.com/video_elevacion_muñeca_pronacion_barra.mp4",
        focusLevels: {'Antebrazo': 3, 'Bíceps': 2, 'Hombros': 1},
        equipment: ['Barra recta'],
        tags: [
          'Elevación de muñeca en pronación con barra',
          'Antebrazo',
          'Bíceps',
          'Ejercicio de aislamiento'
        ],
      );

// Elevación de muñeca en supinación con barra
      Exercise elevacionMunecaSupinacionBarraExercise = Exercise(
        name: "Elevación de muñeca en supinación con barra",
        primaryFocus: "Antebrazo",
        secondaryFocus: "Bíceps",
        description:
            "La elevación de muñeca en supinación con barra es un ejercicio que se centra en fortalecer los músculos del antebrazo, especialmente los extensores de la muñeca y los músculos del bíceps. Se realiza de pie, sosteniendo una barra con un agarre supino (palmas hacia arriba). Se elevan las muñecas hacia arriba y luego se bajan controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_muñeca_supinacion_barra.png",
        videoLink:
            "https://ejemplo.com/video_elevacion_muñeca_supinacion_barra.mp4",
        focusLevels: {'Antebrazo': 3, 'Bíceps': 2, 'Hombros': 1},
        equipment: ['Barra recta'],
        tags: [
          'Elevación de muñeca en supinación con barra',
          'Antebrazo',
          'Bíceps',
          'Ejercicio de aislamiento'
        ],
      );

      Exercise extensionesCuadricepsMaquinaExercise = Exercise(
        name: "Extensiones de cuádriceps en máquina",
        primaryFocus: "Cuádriceps",
        secondaryFocus: "Femoral",
        description:
            "Las extensiones de cuádriceps en máquina son un ejercicio efectivo para aislar y fortalecer los músculos del cuádriceps. Se realiza sentado en una máquina de extensión de piernas con los pies debajo de las almohadillas. Se extienden las piernas hacia adelante, manteniendo la espalda pegada al respaldo y controlando el movimiento en todo momento.",
        representativeImageLink:
            "https://ejemplo.com/imagen_extensiones_cuadriceps_maquina.png",
        videoLink:
            "https://ejemplo.com/video_extensiones_cuadriceps_maquina.mp4",
        focusLevels: {'Cuádriceps': 3, 'Femoral': 2, 'Glúteos': 1},
        equipment: ['Máquina de extensión de piernas'],
        tags: [
          'Extensiones de cuádriceps en máquina',
          'Cuádriceps',
          'Femoral',
          'Ejercicio de aislamiento'
        ],
      );

// Prensa de piernas
      Exercise prensaPiernasExercise = Exercise(
        name: "Prensa de piernas",
        primaryFocus: "Cuádriceps",
        secondaryFocus: "Glúteos",
        description:
            "La prensa de piernas es un ejercicio excelente para trabajar los músculos de las piernas, en especial los cuádriceps y los glúteos. Se realiza en una máquina de prensa de piernas, donde se empuja un peso hacia arriba con los pies mientras se mantienen las piernas flexionadas.",
        representativeImageLink:
            "https://ejemplo.com/imagen_prensa_piernas.png",
        videoLink: "https://ejemplo.com/video_prensa_piernas.mp4",
        focusLevels: {'Cuádriceps': 3, 'Glúteos': 2, 'Femoral': 1},
        equipment: ['Máquina de prensa de piernas'],
        tags: [
          'Prensa de piernas',
          'Cuádriceps',
          'Glúteos',
          'Ejercicio compuesto'
        ],
      );

// Zancadas
      Exercise zancadasExercise = Exercise(
        name: "Zancadas",
        primaryFocus: "Cuádriceps",
        secondaryFocus: "Glúteos",
        description:
            "Las zancadas son un ejercicio efectivo para trabajar los músculos de las piernas, incluyendo los cuádriceps y los glúteos. Se realizan dando un paso hacia adelante con una pierna y bajando el cuerpo hasta que ambas rodillas estén dobladas en un ángulo de 90 grados, luego se vuelve a la posición inicial.",
        representativeImageLink: "https://ejemplo.com/imagen_zancadas.png",
        videoLink: "https://ejemplo.com/video_zancadas.mp4",
        focusLevels: {'Cuádriceps': 3, 'Glúteos': 2, 'Femoral': 1},
        equipment: [],
        tags: ['Zancadas', 'Cuádriceps', 'Glúteos', 'Ejercicio compuesto'],
      );

// Sentadilla hack
      Exercise sentadillaHackExercise = Exercise(
        name: "Sentadilla hack",
        primaryFocus: "Cuádriceps",
        secondaryFocus: "Glúteos",
        description:
            "La sentadilla hack es un ejercicio que se enfoca en los cuádriceps y los glúteos. Se realiza en una máquina de sentadilla hack, donde el cuerpo se desplaza hacia abajo y hacia arriba manteniendo los pies en una posición fija en una plataforma.",
        representativeImageLink:
            "https://ejemplo.com/imagen_sentadilla_hack.png",
        videoLink: "https://ejemplo.com/video_sentadilla_hack.mp4",
        focusLevels: {'Cuádriceps': 3, 'Glúteos': 2, 'Femoral': 1},
        equipment: ['Máquina de sentadilla hack'],
        tags: [
          'Sentadilla hack',
          'Cuádriceps',
          'Glúteos',
          'Ejercicio compuesto'
        ],
      );

// Extensiones de cuádriceps con una pierna
      Exercise extensionesCuadricepsUnaPiernaExercise = Exercise(
        name: "Extensiones de cuádriceps con una pierna",
        primaryFocus: "Cuádriceps",
        secondaryFocus: "Femoral",
        description:
            "Las extensiones de cuádriceps con una pierna son un ejercicio que se centra en fortalecer los cuádriceps de manera unilateral. Se realiza en una máquina de extensión de piernas ajustando el apoyo para que solo una pierna realice el movimiento de extensión.",
        representativeImageLink:
            "https://ejemplo.com/imagen_extensiones_cuadriceps_una_pierna.png",
        videoLink:
            "https://ejemplo.com/video_extensiones_cuadriceps_una_pierna.mp4",
        focusLevels: {'Cuádriceps': 3, 'Femoral': 2, 'Glúteos': 1},
        equipment: ['Máquina de extensión de piernas'],
        tags: [
          'Extensiones de cuádriceps con una pierna',
          'Cuádriceps',
          'Femoral',
          'Ejercicio de aislamiento'
        ],
      );

// Peso muerto rumano
      Exercise pesoMuertoRumanoExercise = Exercise(
        name: "Peso muerto rumano",
        primaryFocus: "Femoral",
        secondaryFocus: "Glúteos",
        description:
            "El peso muerto rumano es un ejercicio excelente para fortalecer los músculos de la cadena posterior, incluyendo los isquiotibiales y los glúteos. Se realiza manteniendo las piernas ligeramente flexionadas, inclinando el torso hacia adelante desde las caderas mientras se baja la barra por las piernas, manteniendo la espalda recta.",
        representativeImageLink:
            "https://ejemplo.com/imagen_peso_muerto_rumano.png",
        videoLink: "https://ejemplo.com/video_peso_muerto_rumano.mp4",
        focusLevels: {'Femoral': 3, 'Glúteos': 2, 'Espalda baja': 1},
        equipment: ['Barra'],
        tags: [
          'Peso muerto rumano',
          'Femoral',
          'Glúteos',
          'Ejercicio compuesto'
        ],
      );

// Curl femoral en máquina
      Exercise curlFemoralMaquinaExercise = Exercise(
        name: "Curl femoral en máquina",
        primaryFocus: "Femoral",
        secondaryFocus: "Glúteos",
        description:
            "El curl femoral en máquina es un ejercicio que se centra en fortalecer los músculos isquiotibiales. Se realiza acostado en una máquina específica para curl femoral, flexionando las piernas desde las rodillas hacia los glúteos y luego bajando controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_curl_femoral_maquina.png",
        videoLink: "https://ejemplo.com/video_curl_femoral_maquina.mp4",
        focusLevels: {'Femoral': 3, 'Glúteos': 2, 'Cuádriceps': 1},
        equipment: ['Máquina de curl femoral'],
        tags: [
          'Curl femoral en máquina',
          'Femoral',
          'Glúteos',
          'Ejercicio de aislamiento'
        ],
      );

// Peso muerto convencional
      Exercise pesoMuertoConvencionalExercise = Exercise(
        name: "Peso muerto convencional",
        primaryFocus: "Femoral",
        secondaryFocus: "Glúteos",
        description:
            "El peso muerto convencional es uno de los ejercicios más efectivos para fortalecer la cadena posterior, incluyendo los isquiotibiales y los glúteos, así como también involucra otros grupos musculares como la espalda baja y los músculos del core. Se realiza levantando una barra desde el suelo hasta la cadera, manteniendo la espalda recta y los brazos extendidos.",
        representativeImageLink:
            "https://ejemplo.com/imagen_peso_muerto_convencional.png",
        videoLink: "https://ejemplo.com/video_peso_muerto_convencional.mp4",
        focusLevels: {'Femoral': 3, 'Glúteos': 2, 'Espalda baja': 1},
        equipment: ['Barra'],
        tags: [
          'Peso muerto convencional',
          'Femoral',
          'Glúteos',
          'Ejercicio compuesto'
        ],
      );

// Curl femoral tumbado
      Exercise curlFemoralTumbadoExercise = Exercise(
        name: "Curl femoral tumbado",
        primaryFocus: "Femoral",
        secondaryFocus: "Glúteos",
        description:
            "El curl femoral tumbado es un ejercicio efectivo para fortalecer los isquiotibiales. Se realiza acostado boca abajo en una máquina específica para curl femoral, flexionando las piernas desde las rodillas hacia los glúteos y luego bajando controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_curl_femoral_tumbado.png",
        videoLink: "https://ejemplo.com/video_curl_femoral_tumbado.mp4",
        focusLevels: {'Femoral': 3, 'Glúteos': 2, 'Cuádriceps': 1},
        equipment: ['Máquina de curl femoral'],
        tags: [
          'Curl femoral tumbado',
          'Femoral',
          'Glúteos',
          'Ejercicio de aislamiento'
        ],
      );

// Peso muerto rumano

// Elevación de cadera en suelo
      Exercise elevacionCaderaSueloExercise = Exercise(
        name: "Elevación de cadera en suelo",
        primaryFocus: "Glúteos",
        secondaryFocus: "Femoral",
        description:
            "La elevación de cadera en suelo es un ejercicio excelente para activar y fortalecer los glúteos. Se realiza acostado en el suelo con las rodillas flexionadas y los pies apoyados en el suelo. Se elevan las caderas hacia arriba, contrayendo los glúteos en la parte superior del movimiento.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_cadera_suelo.png",
        videoLink: "https://ejemplo.com/video_elevacion_cadera_suelo.mp4",
        focusLevels: {'Glúteos': 3, 'Femoral': 2, 'Core': 1},
        equipment: [],
        tags: [
          'Elevación de cadera en suelo',
          'Glúteos',
          'Femoral',
          'Ejercicio de aislamiento'
        ],
      );

// Prensa de glúteos
      Exercise prensaGluteosExercise = Exercise(
        name: "Prensa de glúteos",
        primaryFocus: "Glúteos",
        secondaryFocus: "Cuádriceps",
        description:
            "La prensa de glúteos es un ejercicio que se centra en fortalecer los músculos de los glúteos. Se realiza en una máquina específica para prensa de glúteos, donde se empuja un peso hacia atrás con los pies mientras se mantienen las rodillas flexionadas.",
        representativeImageLink:
            "https://ejemplo.com/imagen_prensa_gluteos.png",
        videoLink: "https://ejemplo.com/video_prensa_gluteos.mp4",
        focusLevels: {'Glúteos': 3, 'Cuádriceps': 2, 'Femoral': 1},
        equipment: ['Máquina de prensa de glúteos'],
        tags: [
          'Prensa de glúteos',
          'Glúteos',
          'Cuádriceps',
          'Ejercicio compuesto'
        ],
      );

// Caminar en cuclillas
      Exercise caminarCuclillasExercise = Exercise(
        name: "Caminar en cuclillas",
        primaryFocus: "Glúteos",
        secondaryFocus: "Cuádriceps",
        description:
            "Caminar en cuclillas es un ejercicio desafiante que involucra los glúteos y los cuádriceps. Se realiza caminando mientras se mantiene una posición de cuclillas, manteniendo la espalda recta y el peso en los talones.",
        representativeImageLink:
            "https://ejemplo.com/imagen_caminar_cuclillas.png",
        videoLink: "https://ejemplo.com/video_caminar_cuclillas.mp4",
        focusLevels: {'Glúteos': 3, 'Cuádriceps': 2, 'Femoral': 1},
        equipment: [],
        tags: [
          'Caminar en cuclillas',
          'Glúteos',
          'Cuádriceps',
          'Ejercicio compuesto'
        ],
      );

// Glute bridge
      Exercise gluteBridgeExercise = Exercise(
        name: "Glute bridge",
        primaryFocus: "Glúteos",
        secondaryFocus: "Femoral",
        description:
            "El Glute Bridge es un ejercicio efectivo para activar los glúteos y fortalecer la cadena posterior. Se realiza acostado boca arriba con las rodillas flexionadas y los pies apoyados en el suelo. Se elevan las caderas hacia arriba, manteniendo una línea recta desde los hombros hasta las rodillas.",
        representativeImageLink: "https://ejemplo.com/imagen_glute_bridge.png",
        videoLink: "https://ejemplo.com/video_glute_bridge.mp4",
        focusLevels: {'Glúteos': 3, 'Femoral': 2, 'Core': 1},
        equipment: [],
        tags: [
          'Glute bridge',
          'Glúteos',
          'Femoral',
          'Ejercicio de aislamiento'
        ],
      );

// Elevación de talones de pie con barra
      Exercise elevacionTalonesPieBarraExercise = Exercise(
        name: "Elevación de talones de pie con barra",
        primaryFocus: "Gemelos",
        secondaryFocus: "",
        description:
            "La elevación de talones de pie con barra es un ejercicio efectivo para fortalecer los músculos de los gemelos. Se realiza de pie con una barra sobre los hombros y los talones elevados, luego se baja los talones hacia el suelo y se vuelve a la posición inicial.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_talones_pie_barra.png",
        videoLink: "https://ejemplo.com/video_elevacion_talones_pie_barra.mp4",
        focusLevels: {'Gemelos': 3, 'Antebrazo': 2},
        equipment: ['Barra'],
        tags: [
          'Elevación de talones de pie con barra',
          'Gemelos',
          'Ejercicio compuesto'
        ],
      );

// Elevación de talones de pie con mancuernas
      Exercise elevacionTalonesPieMancuernasExercise = Exercise(
        name: "Elevación de talones de pie con mancuernas",
        primaryFocus: "Gemelos",
        secondaryFocus: "",
        description:
            "La elevación de talones de pie con mancuernas es un ejercicio que se enfoca en fortalecer los músculos de los gemelos. Se realiza de pie con mancuernas en las manos y los talones elevados, luego se baja los talones hacia el suelo y se vuelve a la posición inicial.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_talones_pie_mancuernas.png",
        videoLink:
            "https://ejemplo.com/video_elevacion_talones_pie_mancuernas.mp4",
        focusLevels: {'Gemelos': 3, 'Antebrazo': 2},
        equipment: ['Mancuernas'],
        tags: [
          'Elevación de talones de pie con mancuernas',
          'Gemelos',
          'Ejercicio compuesto'
        ],
      );

// Elevación de talones en máquina
      Exercise elevacionTalonesMaquinaExercise = Exercise(
        name: "Elevación de talones en máquina",
        primaryFocus: "Gemelos",
        secondaryFocus: "",
        description:
            "La elevación de talones en máquina es un ejercicio que se centra en fortalecer los músculos de los gemelos. Se realiza en una máquina específica para talones, donde se eleva los talones hacia arriba y luego se baja controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_talones_maquina.png",
        videoLink: "https://ejemplo.com/video_elevacion_talones_maquina.mp4",
        focusLevels: {'Gemelos': 3, 'Antebrazo': 2},
        equipment: ['Máquina para elevación de talones'],
        tags: [
          'Elevación de talones en máquina',
          'Gemelos',
          'Ejercicio de aislamiento'
        ],
      );

// Elevación de talones sentado
      Exercise elevacionTalonesSentadoExercise = Exercise(
        name: "Elevación de talones sentado",
        primaryFocus: "Gemelos",
        secondaryFocus: "",
        description:
            "La elevación de talones sentado es un ejercicio que se enfoca en fortalecer los músculos de los gemelos. Se realiza sentado en una máquina específica para talones, donde se eleva los talones hacia arriba y luego se baja controladamente.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_talones_sentado.png",
        videoLink: "https://ejemplo.com/video_elevacion_talones_sentado.mp4",
        focusLevels: {'Gemelos': 3, 'Antebrazo': 2},
        equipment: ['Máquina para elevación de talones'],
        tags: [
          'Elevación de talones sentado',
          'Gemelos',
          'Ejercicio de aislamiento'
        ],
      );

// Crunch abdominal
      Exercise crunchAbdominalExercise = Exercise(
        name: "Crunch abdominal",
        primaryFocus: "Abdomen",
        secondaryFocus: "Core",
        description:
            "El crunch abdominal es un ejercicio clásico para fortalecer los músculos del abdomen. Se realiza acostado boca arriba con las rodillas flexionadas y las manos detrás de la cabeza. Se eleva el torso hacia las rodillas, contrayendo los abdominales en la parte superior del movimiento.",
        representativeImageLink:
            "https://ejemplo.com/imagen_crunch_abdominal.png",
        videoLink: "https://ejemplo.com/video_crunch_abdominal.mp4",
        focusLevels: {'Abdomen': 3, 'Core': 2},
        equipment: [],
        tags: [
          'Crunch abdominal',
          'Abdomen',
          'Core',
          'Ejercicio de aislamiento'
        ],
      );

// Plancha frontal
      Exercise planchaFrontalExercise = Exercise(
        name: "Plancha frontal",
        primaryFocus: "Abdomen",
        secondaryFocus: "Core",
        description:
            "La plancha frontal es un ejercicio estático que fortalece los músculos del abdomen y del core. Se realiza apoyando el cuerpo en los antebrazos y los pies, manteniendo una posición recta desde la cabeza hasta los talones durante un período de tiempo determinado.",
        representativeImageLink:
            "https://ejemplo.com/imagen_plancha_frontal.png",
        videoLink: "https://ejemplo.com/video_plancha_frontal.mp4",
        focusLevels: {'Abdomen': 3, 'Core': 2},
        equipment: [],
        tags: ['Plancha frontal', 'Abdomen', 'Core', 'Ejercicio isométrico'],
      );

// Plancha lateral
      Exercise planchaLateralExercise = Exercise(
        name: "Plancha lateral",
        primaryFocus: "Abdomen",
        secondaryFocus: "Core",
        description:
            "La plancha lateral es un ejercicio estático que fortalece los músculos del abdomen y del core, centrándose en los oblicuos. Se realiza apoyando el cuerpo de lado en un antebrazo y los pies, manteniendo una posición recta desde la cabeza hasta los pies durante un período de tiempo determinado.",
        representativeImageLink:
            "https://ejemplo.com/imagen_plancha_lateral.png",
        videoLink: "https://ejemplo.com/video_plancha_lateral.mp4",
        focusLevels: {'Abdomen': 3, 'Core': 2},
        equipment: [],
        tags: ['Plancha lateral', 'Abdomen', 'Core', 'Ejercicio isométrico'],
      );

// Elevación de piernas colgado
      Exercise elevacionPiernasColgadoExercise = Exercise(
        name: "Elevación de piernas colgado",
        primaryFocus: "Abdomen",
        secondaryFocus: "Core",
        description:
            "La elevación de piernas colgado es un ejercicio avanzado que fortalece los músculos del abdomen y del core. Se realiza colgando de una barra con los brazos extendidos y elevando las piernas hacia arriba, manteniendo el control y evitando el balanceo del cuerpo.",
        representativeImageLink:
            "https://ejemplo.com/imagen_elevacion_piernas_colgado.png",
        videoLink: "https://ejemplo.com/video_elevacion_piernas_colgado.mp4",
        focusLevels: {'Abdomen': 3, 'Core': 2},
        equipment: ['Barra para dominadas'],
        tags: [
          'Elevación de piernas colgado',
          'Abdomen',
          'Core',
          'Ejercicio avanzado'
        ],
      );

// Russian twist con peso
      Exercise russianTwistPesoExercise = Exercise(
        name: "Russian twist con peso",
        primaryFocus: "Abdomen",
        secondaryFocus: "Oblicuos",
        description:
            "El Russian twist con peso es un ejercicio que fortalece los músculos del abdomen, especialmente los oblicuos. Se realiza sentado con las rodillas flexionadas y los pies apoyados en el suelo, sosteniendo un peso con las manos. Se gira el torso de lado a lado, tocando el suelo a cada lado.",
        representativeImageLink:
            "https://ejemplo.com/imagen_russian_twist_peso.png",
        videoLink: "https://ejemplo.com/video_russian_twist_peso.mp4",
        focusLevels: {'Abdomen': 3, 'Oblicuos': 2},
        equipment: ['Pesas'],
        tags: [
          'Russian twist con peso',
          'Abdomen',
          'Oblicuos',
          'Ejercicio con peso'
        ],
      );

      List<Exercise> exercises = [
        crunchAbdominalExercise,
        planchaFrontalExercise,
        planchaLateralExercise,
        elevacionPiernasColgadoExercise,
        russianTwistPesoExercise,
        elevacionTalonesPieBarraExercise,
        elevacionTalonesPieMancuernasExercise,
        elevacionTalonesMaquinaExercise,
        elevacionTalonesSentadoExercise,
        pressPlanoExercise,
        pressInclinadoExercise,
        pressDeclinadoExercise,
        fondosParalelasExercise,
        aperturasMancuernasExercise,
        pulloverMancuernaExercise,
        flexionesExercise,
        crucesPoleaAltaExercise,
        crucesPoleaMediaExercise,
        crucesPoleaBajaExercise,
        pulloverMaquinaExercise,
        remoSentadoPoleaExercise,
        hipThrustExercise,
        remoBarraExercise,
        pesoMuertoExercise,

        ///pullDownPoleaAltaExercise,
        remoPoleaSentadoExercise,
        pressMilitarExercise,
        elevacionesLateralesMancuernasExercise,
        // elevacionesFrontalesBarraMancuernasExercise,
        facePullsExercise,
        curl21sExercise,
        curlPredicadorExercise,
        curlMartilloMancuernasExercise,
        pressFrancesExercise,
        fondosParalelasExercise,
        //extensionesTricepsPoleaAltaExercise,
        pressTricepsBarraRectaExercise,
        curlMunecaBarraExercise,
        curlMunecaMancuernaExercise,
        reverseCurlMancuernaExercise,
        elevacionMunecaPronacionBarraExercise,
        elevacionMunecaSupinacionBarraExercise,
        extensionesCuadricepsMaquinaExercise,
        prensaPiernasExercise,
        zancadasExercise,
        sentadillaHackExercise,
        extensionesCuadricepsUnaPiernaExercise,
        pesoMuertoRumanoExercise,
        curlFemoralMaquinaExercise,
        pesoMuertoConvencionalExercise,
        curlFemoralTumbadoExercise,
        hipThrustExercise,
        elevacionCaderaSueloExercise,
        prensaGluteosExercise,
        caminarCuclillasExercise,
        gluteBridgeExercise,
      ];

      ExerciseService.agregarEjercicios(context, exercises);

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
