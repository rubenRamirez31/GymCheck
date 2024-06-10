import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/alimento.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/food_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CreateFoodPage extends StatefulWidget {
  @override
  _CreateFoodPageState createState() => _CreateFoodPageState();
}

class _CreateFoodPageState extends State<CreateFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  String? url;
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
                onTap: _seleccionarFoto,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image != null
                          ? ClipRRect(
                              // ClipRRect para redondear las esquinas de la imagen
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                            ),
                    ),
                    if (_image != null) // Botón de quitar imagen
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                        ),
                      ),
                  ],
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
                  CustomButton(
                    onPressed: () {
                      if (_image == null) {
                        TrackingWidgets.showInfo(
                          context,
                          'Error al crear la receta',
                          'Debes de agregar una imagen representativa',
                        );
                      } else if (_formKey.currentState!.validate()) {
                        _crearAlimento();
                      }
                    },
                    text: 'Crear Receta',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarFoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
          url = pickedImage.name;
        });
      }
    } catch (error) {
      print('Error al seleccionar la foto de perfil: $error');
      // Manejar el error si es necesario
    }
  }

  void _crearAlimento() async {
    if (_formKey.currentState!.validate()) {
      Globales globales = Provider.of<Globales>(context, listen: false);
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

      
           // Subir la imagen al almacenamiento en la nube
      final storageRef = FirebaseStorage.instance.ref("/Alimentos").child(url!);
      await storageRef.putFile(_image!);

      // Obtener el enlace de descarga de la imagen subida
      final imageUrl = await storageRef.getDownloadURL();

      Food newFood = Food(
        isPublic: _esPublica,
        nick: globales.nick,
        urlImage: imageUrl, // Placeholder, replace with actual image URL
        name: _name,
        description: _description,
        ingredients: _ingredients,
        type: _type,
        preparation: _preparation,
        nutrients: {
          'Proteínas': _proteins,
          'Carbos': _carbs,
          'Grasas': _fats,
        },
      );
      // Print the created Food object
      FoodService.agregarAlimento(context, newFood);
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
                CustomButton(
                  onPressed: () {
                    // Crear otra rutina
                  },
                 text: 'Crear otra alimento',
                ),
                CustomButton(
                  onPressed: () {
                    // Ver todas las rutinas
                  },
                  text: 'Ver todoss los alimentos',
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
