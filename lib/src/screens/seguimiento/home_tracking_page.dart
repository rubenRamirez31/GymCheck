import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/emotional/emotional_tracking_page.dart';
import 'package:gym_check/src/screens/seguimiento/nutritional/nutritional_tracking_page.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeTrackingPage extends StatefulWidget {
  const HomeTrackingPage({Key? key}) : super(key: key);

  @override
  _HomeTrackingPageState createState() => _HomeTrackingPageState();
}

class _HomeTrackingPageState extends State<HomeTrackingPage> {
    final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  int currentPageIndex = 0;
  final List<Widget> pages = [
    const PhysicalTrackingPage(),
    const NutritionalTrackingPage(),
    const EmotionalTrackingPage(),
   
  ];

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
                key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: Colors.indigo,
        
      child: Scaffold(
        //backgroundColor: Colors.amber[100],
        appBar: AppBar(
          backgroundColor: const Color(0xff0C1C2E),
          title: const Text(
            'Seguimiento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          actions: [
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
        body: Column(
          children: [
           
            BottomNavigationBar(
               backgroundColor: Colors.grey,              currentIndex: currentPageIndex,
              onTap: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_run),
                  label: 'Físico',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_dining),
                  label: 'Nutricional',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sentiment_very_satisfied),
                
                  label: 'Nutricional',
                ),
              ],
            ),
             Expanded(
              child: pages[currentPageIndex],
            ),
          ],
        ),
      ),
    );
  }

   Future<void> _handleRefresh() async {
    // Simula una operación de actualización
    await Future.delayed(const Duration(seconds: 3));

   
    // Reinicia la página
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PrincipalPage(initialPageIndex: 2,),
      ),
    );
  }
}
