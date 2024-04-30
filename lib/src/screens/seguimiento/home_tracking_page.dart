import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/goals/goals_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical_tracking_page.dart';

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
              icon: Icon(Icons.flag),
              onPressed: () {
                showModalBottomSheet(
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
                      heightFactor: 0.90,
                      child: GoalsPage(),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.health_and_safety),
              onPressed: () {
                // Acción para el botón de Salud
                print('Botón de Salud presionado');
              },
            ),
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
        body: PhysicalTrackingPage(),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simula una operación de actualización
    await Future.delayed(const Duration(seconds: 3));

    // Reinicia la página
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PrincipalPage(
          initialPageIndex: 2,
        ),
      ),
    );
  }
}
