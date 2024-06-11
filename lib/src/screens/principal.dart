import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/home_create_page.dart';
import 'package:gym_check/src/screens/seguimiento/home_tracking_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/widgets/global/menudrawer.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  final String? uid;
  final int initialPageIndex; // Feed= 0 //Creacion=1 //Seguimiento =2
  final int? initialSubPageIndex; // Por ejemplo seguimiento //Fisico = 0//Nutricional = 1// 
  final int? initialSubPageMenuIndex; // Por ejemplo en seguimiento/fisico //Rutinas = 0 //Registro corporal =1;

  const PrincipalPage({Key? key, this.initialPageIndex = 0, this.initialSubPageIndex, this.initialSubPageMenuIndex, this.uid})
      : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late int currentPageIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? initialSubPageIndex;
  int? initialSubPageMenuIndex;

  @override
  void initState() {
    super.initState();
    // Aquí carga la parte de seguimiento o la que se le pase por defecto
    currentPageIndex = widget.initialPageIndex;
    initialSubPageIndex = widget.initialSubPageIndex ?? Provider.of<GlobalVariablesProvider>(context, listen: false).selectedSubPageTracking;
    initialSubPageMenuIndex = widget.initialSubPageMenuIndex ?? Provider.of<GlobalVariablesProvider>(context, listen: false).selectedMenuOptionTrackingPhysical;
    Provider.of<Globales>(context, listen: false)
        .cargarDatosUsuario(widget.uid.toString());
  }

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    // Resetea las variables iniciales después de acceder a ellas
    final int? subPageIndex = initialSubPageIndex;
    final int? subPageMenuIndex = initialSubPageMenuIndex;
    initialSubPageIndex = null;
    initialSubPageMenuIndex = null;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuDrawer(),
      backgroundColor: Colors.grey,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Feed',
          ),
          
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Crear',
          ),
          NavigationDestination(
            icon: Icon(Icons.radar),
            label: 'Seguimiento',
          ),
        ],
      ),
      body: <Widget>[
        FeedPage(openDrawer: openDrawer),
        HomeCreatePage(openDrawer: openDrawer),
        HomeTrackingPage(
          openDrawer: openDrawer,
          initialPageIndex: subPageIndex,
          initialSubPageMenuIndex: subPageMenuIndex,
        ),
      ][currentPageIndex],
    );
  }
}
