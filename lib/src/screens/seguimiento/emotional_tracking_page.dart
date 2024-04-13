import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/crear/create_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/bottom_navigation_menu.dart';
import 'package:gym_check/src/widgets/custom_app_bar.dart';
import 'package:gym_check/src/widgets/seguimiento/tracking_option_widget.dart';
import 'package:provider/provider.dart';

class EmotionalTrackingPage extends StatefulWidget {
  @override
  _EmotionalTrackingPageState createState() => _EmotionalTrackingPageState();
}

class _EmotionalTrackingPageState extends State<EmotionalTrackingPage> {
  int _selectedPage = 0;
  int _selectedSubPage = 1;
  String _nick = '';
  String _urlImagen = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedPage = index;
    });

    switch (index) {
      case 0:
        // Navegar a la página de FeedPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
        break;
      case 1:
        // Navegar a la página de creación de publicaciones
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePage()),
        );
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
     var globalVariable = Provider.of<GlobalVariablesProvider>(context); // Obtiene la instancia de GlobalVariable
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Seguimiento',
        //profileImageUrl: _urlImagen,
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
            icon: Icon(Icons.message), // Botón de mensajes
            onPressed: () {
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
                    // globalVariable.selectedSubPageTracking = 1;
                    _selectedSubPage = index;
                   
//print( 'Provider en emotional '+globalVariable.selectedSubPageTracking.toString());
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Color.fromARGB(255, 6, 218, 255),
              height: 250,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: 20),
            Container(
              color: const Color.fromARGB(255, 239, 241, 239),
              height: 250,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: 20),
            Container(
              color: Color.fromARGB(255, 0, 0, 0),
              height: 250,
              width: MediaQuery.of(context).size.width,
            ),
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
