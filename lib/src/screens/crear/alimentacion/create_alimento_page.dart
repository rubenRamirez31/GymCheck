import 'package:flutter/material.dart';
import 'package:gym_check/src/models/alimento.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateFoodPage extends StatefulWidget {
  @override
  _CreateFoodPageState createState() => _CreateFoodPageState();
}

class _CreateFoodPageState extends State<CreateFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  String _name = '';
  String _description = '';
  List<String> _ingredients = [];
  String _type = 'Desayuno';
  String _preparation = '';
  int _proteins = 0;
  int _carbs = 0;
  int _fats = 0;
  bool _esPublica = false;
  void _setImage(File image) {
    setState(() {
      _image = image;
    });
  }

  // Future<void> _selectImage() async {
  //   final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     _setImage(File(pickedFile.path));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Crear Alimento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Cambia el color del icono de retroceso a blanco
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              //agregarEjercicio();
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                //onTap: print("d"),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: 'Nombre (max. 15 caracteres)'),
                maxLength: 15,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: 'Descripción (max. 120 caracteres)'),
                maxLength: 120,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: 'Ingredientes'),
                maxLines: null,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los ingredientes';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _ingredients = value.split('\n');
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _type,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  labelStyle: TextStyle(
                      color: Colors.white), // Color del texto de la etiqueta
                  filled: true, // Para que el fondo se llene
                  //fillColor: Colors.black, // Color de fondo negro
                ),
                dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                items: <String>[
                  'Desayuno',
                  'Comida',
                  'Cena',
                  'Merienda',
                  'Bebida'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          color: Colors.white), // Color del texto en blanco
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: 'Preparación (max. 500 caracteres)'),
                     style: const TextStyle(color: Colors.white),
                maxLength: 500,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los pasos de preparación';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _preparation = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Información Nutricional',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      // Agrega aquí la lógica para mostrar información
                    },
                    icon: const Icon(
                      Icons.info,
                      color: Colors.white, // Color blanco
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Proteínas (g)'),
                keyboardType: TextInputType.number,
                 style: const TextStyle(color: Colors.white),
                onChanged: (value) {

                  setState(() {
                    _proteins = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Carbohidratos (g)'),
                keyboardType: TextInputType.number,
                 style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _carbs = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Grasas (g)'),
                keyboardType: TextInputType.number,
                 style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _fats = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 15),
              CheckboxListTile(
                title: const Text(
                  '¿Es pública?',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                value: _esPublica,
                onChanged: (value) {
                  setState(() {
                    _esPublica = value!;
                  });
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _crearAlimento();
                      }
                    },
                    child: const Text('Crear Receta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _crearAlimento() async {
    if (_formKey.currentState!.validate()) {
      // Mostrar AlertDialog mientras se crea la rutina
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: Text(
              'Creando...',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Color del indicador de progreso blanco
            ),
          );
        },
      );

      Food newFood = Food(
        urlImage: '', // Placeholder, replace with actual image URL
        name: _name,
        description: _description,
        ingredients: _ingredients,
        type: _type,
        preparation: _preparation,
        nutrients: {
          'proteins': _proteins,
          'carbs': _carbs,
          'fats': _fats,
        },
      );
      // Print the created Food object
      print(newFood.toJson());

      // Variables para almacenar la suma de los enfoques de los músculos

      // Simular un retraso de 2 segundos para la creación de la rutina
      await Future.delayed(const Duration(seconds: 2));

      // Cerrar el AlertDialog de creación
      Navigator.of(context).pop();
      // Navegar a la página anterior
      Navigator.pop(context);

      // Mostrar AlertDialog después de crear la rutina
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Fondo negro
            title: const Text(
              'Alimento creado',
              style: TextStyle(color: Colors.white), // Letras blancas
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Este alimento ha sido almacenada en la sección "Alimentos", y puede encontrarla en "Creado por mí".',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Crear otra rutina
                  },
                  child: const Text('Crear otra alimento',
                      style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Ver todas las rutinas
                  },
                  child: const Text('Ver todoss los alimentos',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
