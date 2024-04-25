import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/crear/ejercicios/create_exercise_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/home_tracking_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';

class PrincipalPage extends StatefulWidget {
  final int initialPageIndex;

  const PrincipalPage({Key? key, this.initialPageIndex = 0}) : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.amber[100],
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
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Yo',
          ),
        ],
      ),
      body: <Widget>[
        const FeedPage(),
        const CreateExercisePage(),
        const HomeTrackingPage(),
      ][currentPageIndex],
    );
  }
}
