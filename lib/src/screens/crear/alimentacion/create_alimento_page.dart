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
        title: Text('Crear Alimento'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
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
                      : Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                        ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre (max. 15 caracteres)'),
                maxLength: 15,
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
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción (max. 120 caracteres)'),
                maxLength: 120,
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
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ingredientes'),
                maxLines: null,
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
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: <String>['Desayuno', 'Comida', 'Cena', 'Merienda', 'Bebida']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preparación (max. 500 caracteres)'),
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
              SizedBox(height: 20),
              Text(
                'Información Nutricional',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Proteínas (g)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _proteins = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Carbohidratos (g)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _carbs = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Grasas (g)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _fats = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create Food object
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
                  }
                },
                child: Text('Crear Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
