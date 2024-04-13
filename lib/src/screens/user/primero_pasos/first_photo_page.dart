import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FirstPhotoPage extends StatefulWidget {
  @override
  _FirstPhotoPageState createState() => _FirstPhotoPageState();
}

class _FirstPhotoPageState extends State<FirstPhotoPage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Foto de Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(), // Mostrar la imagen seleccionada si existe

            _imageFile != null
                ? ElevatedButton(
                    onPressed: () => _subirFoto(context),
                    child: Text('Continuar'),
                  )
                : SizedBox(height: 20),
            SizedBox(height: 20),

            _imageFile == null
                ? ElevatedButton(
                    onPressed: _seleccionarFoto,
                    child: Text('Agregar Foto'),
                  )
                : Container(),
            _imageFile != null
                ? SizedBox(height: 20)
                : ElevatedButton(
                    onPressed: () => _subirDespues(context),
                    child: Text('Agregar Foto Después'),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _seleccionarFoto,
        tooltip: 'Seleccionar Foto',
        child: Icon(Icons.add_a_photo),
      ),
    );
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

  Future<void> _subirFoto(BuildContext context) async {
    try {
      if (_imageFile != null) {
        // Obtener el ID de usuario
        String userId = Provider.of<UserSessionProvider>(context, listen: false)
            .userSession!
            .userId;

        // Crear objeto User con la foto de perfil
        User user = User(fotoPerfil: _imageFile, primerosPasos: 3);

        // Actualizar usuario con la foto de perfil
        await UserService.updateUser(userId, user);

        // Redirigir a la página de body_data_page
        Navigator.pushNamed(context, '/body_data');
      }
    } catch (error) {
      print('Error al subir la foto de perfil: $error');
      // Manejar el error si es necesario
    }
  }

  Future<void> _subirDespues(BuildContext context) async {
    try {
      // Obtener el ID de usuario
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;

      // Crear objeto User con el campo 'primerosPasos' igual a 3
      User user = User(primerosPasos: 3);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(userId, user);

      // Redirigir a la página de body_data_page
      Navigator.pushNamed(context, '/body_data');
    } catch (error) {
      print('Error al agregar foto después: $error');
      // Manejar el error si es necesario
    }
  }
}
