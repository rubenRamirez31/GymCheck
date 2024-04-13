import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/crear/create_page.dart';
import 'package:gym_check/src/screens/crear/dietas/create_diets_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/create_exercise_page.dart';
import 'package:gym_check/src/screens/seguimiento/emotional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/body_data_tracking_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/bottom_navigation_menu.dart';
import 'package:gym_check/src/widgets/create_button_widget.dart';
import 'package:gym_check/src/widgets/custom_app_bar.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:gym_check/src/widgets/seguimiento/data_tracking_widget.dart';
import 'package:gym_check/src/widgets/seguimiento/tracking_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhysicalTrackingPage extends StatefulWidget {
  
  @override
  _PhysicalTrackingPageState createState() => _PhysicalTrackingPageState();
}

class _PhysicalTrackingPageState extends State<PhysicalTrackingPage> {
  
  int _selectedPage = 0;
  int _selectedSubPage = 0;
  int _selectedMenuOption = 0;
  String _nick = '';
  String _urlImagen = '';



  List<String> options = [
    'Datos Corporales',
    'Metas ',
    'PR',
    'General',
    'Configuraciones'
  ]; // Lista de opciones


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSelectedMenuOption(); // Cargar el estado guardado de _selectedMenuOption
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = prefs.getInt('selectedMenuOption') ?? 0;
    });
  }

  void _onTabTapped(int index) {
        var globalVariable =
        Provider.of<GlobalVariablesProvider>(context, listen: false);
    setState(() {
      _selectedPage = index;
    });

    switch (index) {
       
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
        break;
      case 1:
         // Navegar a la página de creación dependiendo su ultimo estado

        if (globalVariable.selectedSubPageCreate == 0) {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateExercisePage()),
          );

        } else if (globalVariable.selectedSubPageCreate == 1){
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDietPage()),);
        }
        break;
  
      case 2:
        // Ya estamos en la página de seguimiento, no hay acción necesaria
        break;
    }
  }

  Future<void> _loadUserData() async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      setState(() {
        _nick = userData['nick'];
        _urlImagen = userData['urlImagen'];
      });
    } catch (error) {
      print('Error al cargar los datos del usuario: $error');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(
        context); // Obtiene la instancia de GlobalVariable

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Seguimiento',
        // profileImageUrl: _urlImagen,
        onProfilePressed: () {},
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Botón de búsqueda
            onPressed: () {
              // Acción al presionar el botón de búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications), // Botón de notificaciones
            onPressed: () {
              // Acción al presionar el botón de notificaciones
            },
          ),
          IconButton(
            icon: Icon(Icons.info), // Botón de mensajes
            onPressed: () {
              setState(() {
                print("Global " +
                    globalVariable.selectedMenuOptionTrackingPhysical
                        .toString());
              });
              // Acción al presionar el botón de mensajes
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: TrackingOptionWidget(
                selectedIndex: _selectedSubPage,
                onItemSelected: (index) {
                  setState(() {

                    _selectedSubPage = index;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
      
            Text("Aqui va el calendario ñejeje"),
            Container(
              color: Colors.green,
              height: 50,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(),

             CreateButton(
          text: 'Crear',
          buttonColor: Colors.blue,
          onPressed: () {
            // Aquí puedes definir qué hacer cuando se presiona el botón
            print('Botón presionado');
          },
          iconData: Icons.abc,
          iconColor: Colors.white,
        ),

            SizedBox(height: 20),
            Container(
              color: Color.fromARGB(255, 255, 255, 255),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      highlightColor: Colors.green,
                      onItemSelected: (index) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          _selectedMenuOption = index;
                          globalVariable.selectedMenuOptionTrackingPhysical =
                              _selectedMenuOption;
                        });
                        await prefs.setInt('selectedMenuOption', index);
                      },
                    ),
                    // Aquí puedes agregar más elementos MenuButtonOption según sea necesario
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            _selectedMenuOption == 0
                ? BodyDataTrackingPage()
                : SizedBox(), // Si _selectedMenuOption no es 0, no mostrar el contenedor
            _selectedMenuOption == 1
                ? Container(
                    color: Color.fromARGB(255, 0, 255, 0), // Contenedor verde
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : SizedBox(), // Si _selectedMenuOption no es 1, no mostrar el contenedor
            _selectedMenuOption == 2
                ? Container(
                    color: Color.fromARGB(255, 0, 0, 255), // Contenedor azul
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : SizedBox(), // Si _selectedMenuOption no es 2, no mostrar el contenedor
            _selectedMenuOption == 3
                ? Container(
                    color:
                        Color.fromARGB(255, 255, 255, 0), // Contenedor amarillo
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : SizedBox(), // Si _selectedMenuOption no es 3, no mostrar el contenedor
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationMenu(
            selectedIndex: 2,
            onTabTapped: _onTabTapped,
          ),
        ],
      ),
    );
  }
}
