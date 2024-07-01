import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/components/app_text_form_field.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nickController;
  late TextEditingController _estadoController;
  late TextEditingController _nombreController;
    late String _dropdownValue;

  late String _initialNick;
  late String _initialEstado;
  late String _initialNombre;
  late String _initialGenero;
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    final globales = Provider.of<Globales>(context, listen: false);
    _initialNick = globales.nick;
    _initialEstado = globales.estado ?? "";
    _initialNombre = globales.primerNombre;
    _initialGenero = "Binario";
    _nickController = TextEditingController(text: _initialNick);
    _estadoController = TextEditingController(text: _initialEstado);
    _nombreController = TextEditingController(text: _initialNombre);
    _imageUrl = globales.fotoPerfil;
    _dropdownValue = _initialGenero; // Inicializar con el género actual del usuario
    print(globales.genero);
  }

  @override
  Widget build(BuildContext context) {

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff0C1C2E),
          title: const Text(
            'Editar perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (_imageUrl != null ? NetworkImage(_imageUrl!) : null)
                            as ImageProvider?,
                    child: _imageFile == null && _imageUrl == null
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  TextButton(
                    onPressed: () => _showPhotoOptions(context),
                    child: Text(
                      'Editar foto de perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Nombre',
                    keyboardType: TextInputType.text,
                    controller: _nombreController,
                    textStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color.fromARGB(255, 18, 18, 18),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Nombre de usuario',
                    keyboardType: TextInputType.text,
                    controller: _nickController,
                    textStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color.fromARGB(255, 18, 18, 18),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nick';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    labelText: 'Presentacion',
                    keyboardType: TextInputType.text,
                    controller: _estadoController,
                    textStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color.fromARGB(255, 18, 18, 18),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Género',
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(255, 18, 18, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.white), // Color del borde
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _dropdownValue,
                  
                    onChanged: (String? value) {
                      setState(() {
                        _dropdownValue = value!;
                      });
                    },
                    dropdownColor: const Color.fromARGB(255, 55, 55, 55),
                    items: <String>['Femenino', 'Masculino', 'Binario']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              color: Colors
                                  .white), // Establece el color del texto en blanco
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Guardar",
                    onPressed: () {
                      _updateProfile();
                    },
                    icon: Icons.save,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkNickUniqueness(String nick) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Usuarios')
        .where('nick', isEqualTo: nick)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final globales = Provider.of<Globales>(context, listen: false);

      // Verificar la unicidad del nick
      bool nickExists = await _checkNickUniqueness(_nickController.text);
      if (nickExists && _nickController.text != _initialNick) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('El nick ya está en uso.')));
        return;
      }

      Map<String, dynamic> newData = {
        'nick': _nickController.text,
        'estado': _estadoController.text,
        'primer_nombre': _nombreController.text,
        'genero': _dropdownValue,
      };

      if (_imageFile != null) {
        await _subirFoto(context);
        newData['urlImagen'] = _imageUrl;
      }

      String result = await UserService.updateUser(newData, context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));

      // Actualizar los datos globales
      globales.nick = _nickController.text;
      globales.estado = _estadoController.text;
      globales.primerNombre = _nombreController.text;
      if (_imageUrl != null) {
        globales.fotoPerfil = _imageUrl!;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrincipalPage(),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_nickController.text != _initialNick ||
        _estadoController.text != _initialEstado ||
        _nombreController.text != _initialNombre ||
        _dropdownValue != _initialGenero ||
        _imageFile != null) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Descartar cambios?'),
              content: Text('Si regresas, los cambios no se guardarán.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Salir'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  Future<void> _seleccionarFoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } catch (error) {
      print('Error al seleccionar la foto de perfil: $error');
      // Manejar el error si es necesario
    }
  }

  Future<void> _tomarFoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } catch (error) {
      print('Error al tomar la foto de perfil: $error');
      // Manejar el error si es necesario
    }
  }

  Future<void> _subirFoto(BuildContext context) async {
    try {
      if (_imageFile != null) {
        // Subir la imagen al almacenamiento en la nube
        final storageRef = FirebaseStorage.instance
            .ref("/profile")
            .child(_imageFile!.path.split('/').last);
        await storageRef.putFile(_imageFile!);

        // Obtener el enlace de descarga de la imagen subida
        _imageUrl = await storageRef.getDownloadURL();
      }
    } catch (error) {
      print('Error al subir la foto de perfil: $error');
      // Manejar el error si es necesario
    }
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: Colors.white,
            ),
            title: Text(
              'Subir foto',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              _seleccionarFoto();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            title: Text(
              'Tomar foto',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _tomarFoto();
            },
          ),
        ],
      ),
    );
  }
}
