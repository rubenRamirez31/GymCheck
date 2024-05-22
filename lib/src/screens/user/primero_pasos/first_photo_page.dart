// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/user/primero_pasos/recomerdar_premium_page.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:image_picker/image_picker.dart';


class FirstPhotoPage extends StatefulWidget {
  const FirstPhotoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstPhotoPageState createState() => _FirstPhotoPageState();
}

class _FirstPhotoPageState extends State<FirstPhotoPage> {
  File? _imageFile;
  String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
                    ? CustomButton(
                        onPressed: () => _seleccionarFoto(),
                        text:'Cambiar Foto',
                         icon: Icons.add_photo_alternate,
                      )
                    : const SizedBox(height: 20),
                const SizedBox(height: 20),
                _imageFile != null
                    ? CustomButton(
                        onPressed: () => _subirFoto(context),
                       text:'Continuar',
                      )
                    : const SizedBox(height: 20),
                const SizedBox(height: 20),

                _imageFile == null
                    ? CustomButton(
                        onPressed: _seleccionarFoto,
                        text:'Agregar Foto',
                        icon: Icons.add_photo_alternate,
                      )
                    : Container(),
                _imageFile != null
                    ? const SizedBox(height: 20)
                    : CustomButton(
                        onPressed: () => _subirDespues(context),
                       text: 'Agregar Foto Después',
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
          url = pickedImage.name;
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
        // Subir la imagen al almacenamiento en la nube
        final storageRef = FirebaseStorage.instance.ref("/profile").child(url!);
        await storageRef.putFile(_imageFile!);

        // Obtener el enlace de descarga de la imagen subida
        final imageUrl = await storageRef.getDownloadURL();

        Map<String, dynamic> userData = {
          'primeros_pasos': 6,
          'urlImagen': imageUrl
        };

        await updateUser(userData, context);

        // Ahora puedes usar la URL de la imagen para almacenarla en tu base de datos o donde la necesites
        print(imageUrl);
        // Redirigir a donde sea necesario después de subir la imagen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const RecomendarPlanPremiumPage()),
        );
      }
    } catch (error) {
      print('Error al subir la foto de perfil: $error');
      // Manejar el error si es necesario
    }
  }

  Future<void> _subirDespues(BuildContext context) async {
    try {
      Map<String, dynamic> userData = {
        'primeros_pasos': 6,
      };

      await updateUser(userData, context);

      // Ahora puedes usar la URL de la imagen para almacenarla en tu base de datos o donde la necesites

      // Redirigir a donde sea necesario después de subir la imagen
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RecomendarPlanPremiumPage()),
      );
    } catch (error) {
      print('Error al agregar foto después: $error');
      // Manejar el error si es necesario
    }
  }
}
