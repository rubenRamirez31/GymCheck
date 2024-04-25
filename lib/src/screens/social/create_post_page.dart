// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/api_service.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController _textoController = TextEditingController();

  File? _image;
  String link = "";
  String url = "";

  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
            color: AppColors.white,
          ), // Icono de una equis
          onPressed: () {
            // Acción al presionar el botón de la equis
            Navigator.pop(context); // Cierra la pantalla actual
          },
        ),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.darkestBlue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  if (_image == null) {
                    try {
                      SmartDialog.showLoading(msg: "Publicando");

                      Post newPost = Post(
                        userId: globales.idAuth,
                        texto: _textoController.text,
                        nick: globales.nick,
                        lugar: "",
                        fechaCreacion: DateTime.now(),
                        urlImagen: link,
                        editad: false,
                      );

                      int resultado = await crearPost(newPost);

                      if (!mounted) return;
                      if (resultado == 200) {
                        SmartDialog.showToast("Publicación Creada");
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/principal", (route) => false);
                      } else {
                        SmartDialog.showToast("Ocurrio un error");
                      }
                    } catch (e) {
                      SmartDialog.dismiss();
                      print(e);
                    }
                  } else {
                    final file = File(_image!.path);

                    final metadata =
                        SettableMetadata(contentType: "image/jpeg");

                    final storageRef = FirebaseStorage.instance.ref("/posts");

                    SmartDialog.showLoading(msg: "Publicando");

                    try {
                      final uploadTask =
                          storageRef.child(url).putFile(file, metadata);
                      await uploadTask.whenComplete(() => null);

                      // Obtener la URL de descarga después de que la carga sea exitosa
                      link = await storageRef.child(url).getDownloadURL();

                      Post newPost = Post(
                        userId: globales.idAuth,
                        texto: _textoController.text,
                        nick: globales.nick,
                        lugar: "",
                        fechaCreacion: DateTime.now(),
                        urlImagen: link,
                        editad: false,
                      );

                      int resultado = await crearPost(newPost);
                      if (!mounted) return;
                      if (resultado == 200) {
                        SmartDialog.dismiss();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/principal", (route) => false);
                        SmartDialog.showToast("Publicación Creada");
                      } else {
                        SmartDialog.showToast("Ocurrio un error");
                      }
                    } catch (e) {
                      SmartDialog.dismiss();
                      print(e);
                    }
                  }
                }
              },
              child: const Text('Publicar')),
          const SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CircleAvatar(
                        radius: 25,
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: globales.fotoPerfil),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: formkey,
                        child: TextFormField(
                          controller: _textoController,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Comparte con los demas',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _image != null
                          ? Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        15), // Borde redondeado
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        15), // Borde redondeado para la imagen
                                    child:
                                        Image.file(_image!, fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: const Color.fromARGB(
                                          198, 197, 185, 185),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                )
              ],
            ),
          )),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 45,
          color: AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: AppColors.darkestBlue,
                onPressed: _getImageCamera,
                icon: const Icon(Icons.camera_alt),
              ),
              IconButton(
                color: AppColors.darkestBlue,
                onPressed: _getImageGallery,
                icon: const Icon(Icons.photo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _getImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
}
