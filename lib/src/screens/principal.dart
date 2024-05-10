import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';

import 'package:gym_check/src/screens/crear/home_create_page.dart';
import 'package:gym_check/src/screens/seguimiento/home_tracking_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/global/menudrawer.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  final String? uid;
  final int initialPageIndex;

  const PrincipalPage({Key? key, this.initialPageIndex = 0, this.uid})
      : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late int currentPageIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
    Provider.of<Globales>(context, listen: false)
        .cargarDatosUsuario(widget!.uid.toString());
  }

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
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
         HomeTrackingPage(openDrawer: openDrawer),
      ][currentPageIndex],
    );
  }
}
