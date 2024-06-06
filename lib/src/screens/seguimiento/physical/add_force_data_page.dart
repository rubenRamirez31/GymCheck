import 'package:flutter/material.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/models/registro_fisico_model.dart';
import 'package:gym_check/src/screens/crear/ejercicios/all_excercise_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/view_excercise_page.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/services/physical_data_service.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/decimal_slider_widget.dart';

class AddForceDataPage extends StatefulWidget {
  final String? exercise; // Nuevo parámetro opcional
  final String? equipament; // Nuevo parámetro opcional

  const AddForceDataPage({Key? key, this.exercise, this.equipament})
      : super(key: key);

  @override
  State<AddForceDataPage> createState() => _AddForceDataPageState();
}

class _AddForceDataPageState extends State<AddForceDataPage> {
  late double _selectedValue = 0;
  late int _selectedEntero = 0;
  late int _selectedDecimal = 0;
  List<Map<String, dynamic>> _ejercicios = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (widget.exercise == null)
                if (_ejercicios.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 75, // Altura máxima de 300 píxeles
                          ),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: _ejercicios
                                .where((item) => item.containsKey('exercise'))
                                .map((item) {
                              Map<String, dynamic> ejercicio = item['exercise'];
                              String nombreEjercicio = ejercicio['nombre'];
                              String id = ejercicio['id'];
                              String equipamiento =
                                  ejercicio['equipmentSelect'];

                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor:
                                        const Color.fromARGB(255, 18, 18, 18),
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
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.96,
                                        child: ViewExercisePage(
                                          id: id,
                                          buttons: false,
                                        ),
                                      );
                                    },
                                  );
                                },
                                key: ValueKey(id),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 83, 83, 83),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$nombreEjercicio / $equipamiento',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _eliminar(item);
                                          },
                                          icon: const Icon(Icons.delete),
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DecimalSlider(
                        selectedDecimal: _selectedEntero,
                        maxValue: 300,
                        onChanged: (value) {
                          setState(() {
                            _selectedEntero = value.toInt();
                            _updateSelectedValue();
                          });
                        },
                      ),
                      DecimalSlider(
                        selectedDecimal: _selectedDecimal,
                        maxValue: 99,
                        onChanged: (value) {
                          setState(() {
                            _selectedDecimal = value;
                            _updateSelectedValue();
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedValue.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          const Text(
                            " ",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          const Text(
                            "Kg",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: () {
                          _guardarDatos(
                              context,
                              '${_ejercicios.first['exercise']['nombre']} con ${_ejercicios.first['exercise']['equipmentSelect']}',
                              _ejercicios.first['exercise']['nombre'],
                              _ejercicios.first['exercise']['equipmentSelect']);
                        },
                        text: 'Agregar',
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: () {
                      _mostrarSeleccionarEjercicio();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 75,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 18, 18, 18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Agregar un ejercicio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              if (widget.exercise != null)
                Column(
                  children: [
                    Text(
                     '${widget.exercise} con ${widget.equipament}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    DecimalSlider(
                      selectedDecimal: _selectedEntero,
                      maxValue: 300,
                      onChanged: (value) {
                        setState(() {
                          _selectedEntero = value.toInt();
                          _updateSelectedValue();
                        });
                      },
                    ),
                    DecimalSlider(
                      selectedDecimal: _selectedDecimal,
                      maxValue: 99,
                      onChanged: (value) {
                        setState(() {
                          _selectedDecimal = value;
                          _updateSelectedValue();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _selectedValue.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        const Text(
                          " ",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        const Text(
                          "Kg",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        _guardarDatos(
                            context,
                            '${widget.exercise} con ${widget.equipament}',
                            widget.exercise!,
                            widget.equipament!);
                      },
                      text: 'Agregar',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateSelectedValue() {
    setState(() {
      _selectedValue = _selectedEntero + (_selectedDecimal / 100);
    });
  }

  void _mostrarSeleccionarEjercicio() async {
    final exercise = await showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      enableDrag: false,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.96,
          child: AllExercisePage(
            agregar: true,
          ),
        );
      },
    );

    if (exercise != null) {
      _configurarEjercicio(exercise);
    }
  }

  void _configurarEjercicio(Exercise exercise) {
    String?
        selectedEquipment; // Variable para almacenar el equipamiento seleccionado

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      enableDrag: false,
      isScrollControlled:
          true, // Permite el desplazamiento cuando el teclado aparece
      builder: (context) {
        return SingleChildScrollView(
          // Envuelve el contenido con SingleChildScrollView
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Agrega ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(exercise.name,
                      style: const TextStyle(
                          color: Colors
                              .white)), // Establece el color del texto en blanco

                  const SizedBox(height: 20),
                  const Text(
                    'Equipamiento:',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors
                            .white), // Establece el color del texto en blanco
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Selecciona un equipamiento',
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(255, 18, 18, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.white), // Color del borde
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedEquipment,
                    onChanged: (String? value) {
                      setState(() {
                        selectedEquipment = value!;
                      });
                    },
                    dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                    items: exercise.equipment.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                              color: Colors
                                  .white), // Establece el color del texto en blanco
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un equipamiento';
                      } else if (value == "Libre") {
                        return 'Por favor elige un equipamiento donde ocupes peso';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar',
                            style: TextStyle(
                                color: Colors
                                    .white)), // Establece el color del texto en blanco
                      ),
                      CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _agregarEjercicio(
                                exercise,
                                selectedEquipment ??
                                    ''); // Pasar el equipamiento seleccionado al método _agregarEjercicio
                            Navigator.of(context).pop();
                          }
                        },
                        text: 'Aceptar',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _guardarDatos(BuildContext context, String tipo, String ejercicio,
      String equipamiento) async {
    try {
      // Mostrar AlertDialog mientras se crea la rutina
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: Text(
              'Subiendo...',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Color del indicador de progreso blanco
            ),
          );
        },
      );

      _selectedValue = double.parse("$_selectedEntero.$_selectedDecimal");

      double valor = _selectedValue; // Utiliza el valor seleccionado

      RegistroFisico bodyData = RegistroFisico(
          tipo: tipo,
          valor: valor,
          ejercicio: ejercicio,
          equipamiento: equipamiento);

      // String coleccion = _getColeccion();

      PhysicalDataService.addData(
          context, "Registro-Fuerza", bodyData.toJson());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Registro creado',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tu nuevo registro ha sido creado exitosamente',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Reinicia la página
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const PrincipalPage(
                          initialPageIndex: 2,
                        ),
                      ),
                    );
                  },
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          );
        },
      );
    } catch (error) {
      print('Error al guardar datos: $error');
    }
  }

  void _agregarEjercicio(Exercise exercise, String selectedEquipment) {
    _ejercicios.add({
      'exercise': {
        'id': exercise.id,
        'nombre': exercise.name.toString(),
        'equipmentList': exercise.equipment,
        'equipmentSelect': selectedEquipment,

        // Aquí puedes agregar más atributos de exercise según sea necesario
      }
    });
    setState(() {});
  }

  void _eliminar(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        title: const Text(
          'Eliminar',
          style: TextStyle(
              color: Colors.white), // Cambia el color del texto a blanco
        ),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este ejercicio?',
          style: TextStyle(
              color: Colors.white), // Cambia el color del texto a blanco
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                  color: Colors.white), // Cambia el color del texto a blanco
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _ejercicios.remove(item);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                  color: Colors.black), // Cambia el color del texto a blanco
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
