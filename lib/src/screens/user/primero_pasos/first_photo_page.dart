// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FirstPhotoPage extends StatefulWidget {
  const FirstPhotoPage({super.key});

  @override
  _FirstPhotoPageState createState() => _FirstPhotoPageState();
}

class _FirstPhotoPageState extends State<FirstPhotoPage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientBackground(
            children: [
              Text(
                'Elige una imagen de perfil',
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text('Selecciona una foto de perfil de tu galeria',
                  style: AppTheme.bodySmall),
            ],
          ),
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imageFile != null
                    ? Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(), // Mostrar la imagen seleccionada si existe
                const SizedBox(height: 20),
                _imageFile != null
                    ? ElevatedButton(
                        onPressed: () => _seleccionarFoto(),
                        child: const Text('Cambiar Imagen'),
                      )
                    : const SizedBox(height: 20),
                const SizedBox(height: 20),
                _imageFile != null
                    ? ElevatedButton(
                        onPressed: () => _subirFoto(context),
                        child: const Text('Continuar'),
                      )
                    : const SizedBox(height: 20),
                const SizedBox(height: 20),

                _imageFile == null
                    ? ElevatedButton(
                        onPressed: _seleccionarFoto,
                        child: const Text('Agregar Foto'),
                      )
                    : Container(),
                _imageFile != null
                    ? const SizedBox(height: 20)
                    : ElevatedButton(
                        onPressed: () => _subirDespues(context),
                        child: const Text('Agregar Foto Después'),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ))
        ],
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
     final globales = Provider.of<Globales>(context, listen: false);

      // Crear objeto User con el campo 'primerosPasos' igual a 3
      User user = User(primerosPasos: 3);

      // Actualizar usuario con el campo 'primerosPasos'
      await UserService.updateUser(globales.idAuth, user);

      // Redirigir a la página de body_data_page
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/body_data');
    } catch (error) {
      print('Error al agregar foto después: $error');
      // Manejar el error si es necesario
    }
  }
}
