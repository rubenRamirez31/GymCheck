import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/screens/crear/rutinas/create_workout_page.dart';
import 'package:gym_check/src/services/serie_service.dart';
import 'package:gym_check/src/services/workout_service.dart';

class ViewWorkoutPage extends StatefulWidget {
  final String id;
  //final bool buttons; // Whether to show action buttons

  const ViewWorkoutPage({Key? key, required this.id,}) : super(key: key);

  @override
  _ViewWorkoutPageState createState() => _ViewWorkoutPageState();
}

class _ViewWorkoutPageState extends State<ViewWorkoutPage> {
  Workout? _workout;

  @override
  void initState() {
    super.initState();
    _loadWorkoutSeries();
  }

  Future<void> _loadWorkoutSeries() async {
    try {
      final workoutSeries = await RutinaService.obtenerRutinaPorId(context, widget.id);
      setState(() {
        _workout = workoutSeries;
      });
    } catch (error) {
      print('Error loading workout series: $error');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      body: _workout != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildImage(),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRowOnly(
                          _workout!.name,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRow(
                          "Primary Focus:", _workout!.primaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRow(
                          "Secondary Focus:", _workout!.secondaryFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildLabelDetailsRow(
                          "Third Focus:", _workout!.thirdFocus),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        _buildSeriesList(),
                      ],
                    ),
                  ),
                ),
             
                  Positioned(
                    top: 80,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xff0C1C2E),
                      tooltip: "Add to routine",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CrearWorkoutPage(serieID: widget.id),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                    ),
                  ),
              
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xff0C1C2E),
                      onPressed: () {
                        // Logic for adding to favorites
                        print('Add to favorites');
                      },
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      width: 200,
      height: 200,
    );
  }

  Widget _buildLabelDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelDetailsRowOnly(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _workout!.series.map((serie) {
        return GestureDetector(
          onTap: () {
            print("Serie ID: ${serie['serie']['id']}");
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  serie['serie']['nombre'],
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
