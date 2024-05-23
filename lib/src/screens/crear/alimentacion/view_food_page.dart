import 'package:flutter/material.dart';
import 'package:gym_check/src/models/alimento.dart';
import 'package:gym_check/src/screens/crear/widgets/create_widgets.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';
import 'package:gym_check/src/services/food_service.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class ViewFoodPage extends StatefulWidget {
  final String id;
  final bool buttons;

  const ViewFoodPage({Key? key, required this.id, required this.buttons})
      : super(key: key);

  @override
  _ViewFoodPageState createState() => _ViewFoodPageState();
}

class _ViewFoodPageState extends State<ViewFoodPage> {
  Food? _food;

  @override
  void initState() {
    super.initState();
    _loadFood();
  }

  Future<void> _loadFood() async {
    try {
      final food = await FoodService.obtenerAlimentoPorId(context, widget.id);
      setState(() {
        _food = food;
      });
    } catch (error) {
      print('Error loading food: $error');
      // Manejo de error si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    Globales globales = Provider.of<Globales>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      body: _food != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildImage(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'creada por',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Acción del botón
                              },
                              child: Text(
                                globales.nick,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (widget.buttons == true)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    // Lógica para agregar a favoritos
                                    print('Agregar a favoritos');
                                  },
                                  fillColor: Colors.grey[200],
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.favorite_border,
                                      color: Colors.black),
                                ),
                                if (_food?.nick == globales.nick)
                                  RawMaterialButton(
                                    onPressed: () {
                                      // Lógica para editar
                                      print('Editar');
                                    },
                                    fillColor: Colors.grey[200],
                                    shape: const CircleBorder(),
                                    child: const Icon(Icons.edit,
                                        color: Colors.black),
                                  ),
                                if (_food?.isPublic == true)
                                  RawMaterialButton(
                                    onPressed: () {
                                      // Lógica para editar
                                      print('Editar');
                                    },
                                    fillColor: Colors.grey[200],
                                    shape: const CircleBorder(),
                                    child: const Icon(Icons.share,
                                        color: Colors.black),
                                  ),
                                RawMaterialButton(
                                    fillColor: Colors.grey[200],
                                    shape: const CircleBorder(),
                                    child: const Icon(Icons.timer_outlined,
                                        color: Colors.black),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddReminderPage(
                                                    tipo: "Alimento",
                                                    alimentoId: widget.id)),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            _food!.name, MainAxisAlignment.center),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            "Descripcion:", MainAxisAlignment.center),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelGeneral(_food!.description, 14),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelGeneralListV2(
                            _food!.ingredients, 14),
                        const SizedBox(height: 10),
                        CreateWidgets.builPreparacion(_food!.preparation),
                        const SizedBox(height: 10),
                        CreateWidgets.buildLabelDetailsRowOnly(
                            "Macros:", MainAxisAlignment.center),
                        const SizedBox(height: 10),
                        _buildNutrients(),
                      ],
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
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _food!.urlImage,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const CircularProgressIndicator();
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text('No hay imagen');
          },
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              child: child,
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
            );
          },
          headers: {
            'Accept': '*/*',
            'User-Agent': 'your_user_agent',
          },
          fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
        ),
      ),
    );
  }

  Widget _buildNutrients() {
    String valor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _food!.nutrients.entries.map((entry) {
        valor = "${entry.value} gr";
        return CreateWidgets.buildLabelDetailsRow(entry.key, valor);
      }).toList(),
    );
  }
}
