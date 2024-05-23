import 'package:flutter/material.dart';
import 'package:gym_check/src/models/alimento.dart';
import 'package:gym_check/src/screens/crear/alimentacion/view_food_page.dart';
import 'package:gym_check/src/services/food_service.dart';

import 'package:gym_check/src/widgets/menu_button_option_widget.dart';

class AllAlimentosPage extends StatefulWidget {
  final bool agregar;

  const AllAlimentosPage({Key? key, required this.agregar}) : super(key: key);

  @override
  _AllAlimentosPageState createState() => _AllAlimentosPageState();
}

class _AllAlimentosPageState extends State<AllAlimentosPage> {
  late Stream<List<Food>> _foodStream;
  TextEditingController _searchController = TextEditingController();
  int _selectedMenuOption = 0;

  List<String> options = ['Creados por mí', 'Todo', 'Favoritos'];
  List<Color> highlightColors = [Colors.white, Colors.white, Colors.white];

  @override
  void initState() {
    super.initState();
    _foodStream = _getFoodStreamForOption(_selectedMenuOption);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 18, 18, 18),
              width: MediaQuery.of(context).size.width - 20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    MenuButtonOption(
                      options: options,
                      highlightColors: highlightColors,
                      onItemSelected: (index) async {
                        setState(() {
                          _selectedMenuOption = index;
                          _foodStream =
                              _getFoodStreamForOption(_selectedMenuOption);
                        });
                      },
                      selectedMenuOptionGlobal: _selectedMenuOption,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Buscar alimento',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _foodStream = obtenerAlimentosFiltradosStream(query,
                      cradospormi: false, todo: false);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<List<Food>>(
              stream: _foodStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final foods = snapshot.data!;
                  return Column(
                    children: foods.map((food) {
                      return FoodContainer(
                        food: food,
                        agregar: widget.agregar,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<Food>> _getFoodStreamForOption(int option) {
    switch (option) {
      case 0:
        return obtenerAlimentosFiltradosStream(_searchController.text,
            cradospormi: true, todo: false);
      case 1:
        return obtenerAlimentosFiltradosStream(_searchController.text,
            cradospormi: false, todo: true);
      case 2:
        return obtenerAlimentosFiltradosStream(_searchController.text,
            cradospormi: false, todo: false);
      default:
        return obtenerTodosAlimentosStream();
    }
  }

  Stream<List<Food>> obtenerTodosAlimentosStream() {
    try {
      final workoutStream = FoodService.obtenerTodosAlimentosStream(context);
      return workoutStream;
    } catch (error) {
      print('Error al obtener todas las rutinas: $error');
      throw error;
    }
  }

  Stream<List<Food>> obtenerAlimentosFiltradosStream(String query,
      {required bool cradospormi, required bool todo}) {
    try {
      final workoutStream = FoodService.obtenerAlimentosFiltradosStream(
        context,
        query,
        cradospormi,
        todo,
      );
      return workoutStream;
    } catch (error) {
      print('Error al obtener las rutinas filtradas: $error');
      throw error;
    }
  }
}class FoodContainer extends StatefulWidget {
  final Food food;
  final bool agregar;

  const FoodContainer({Key? key, required this.food, required this.agregar}) : super(key: key);

  @override
  _FoodContainerState createState() => _FoodContainerState();
}

class _FoodContainerState extends State<FoodContainer> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.agregar == true) {
          Navigator.of(context).pop(widget.food);
        } else {
          // Acción a realizar si no es agregar
        }
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                widget.food.urlImage.isNotEmpty
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.food.urlImage,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('No hay imagen');
                            },
                            frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text('Imagen no encontrada'),
                        ),
                      ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.agregar == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.food.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Tipo: ${widget.food.type}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Creado por: ${widget.food.nick}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                  if (_isFavorite) {
                                    // Lógica para agregar a favoritos
                                  } else {
                                    // Lógica para quitar de favoritos
                                  }
                                });
                              },
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: const Color.fromARGB(255, 18, 18, 18),
                                  scrollControlDisabledMaxHeightRatio: 0.9,
                                  enableDrag: false,
                                  showDragHandle: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.0),
                                    ),
                                  ),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => FractionallySizedBox(
                                    heightFactor: 0.96,
                                    child: ViewFoodPage(
                                      id: widget.food.id ?? '',
                                      buttons: false,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (widget.agregar == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.food.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tipo: ${widget.food.type}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Creado por: ${widget.food.nick}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: const Color.fromARGB(255, 18, 18, 18),
                                  scrollControlDisabledMaxHeightRatio: 0.9,
                                  enableDrag: false,
                                  showDragHandle: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => FractionallySizedBox(
                                    heightFactor: 0.96,
                                    child: ViewFoodPage(
                                      id: widget.food.id ?? '',
                                      buttons: true,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.more_horiz),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                  if (_isFavorite) {
                                    // Lógica para agregar a favoritos
                                  } else {
                                    // Lógica para quitar de favoritos
                                  }
                                });
                              },
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}