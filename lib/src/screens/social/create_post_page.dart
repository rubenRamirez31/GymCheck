// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/services/firebase_services.dart';
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
  bool isButtonEnabled = false;

  File? imagen;
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
          isButtonEnabled
              ? ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      //agregar publicacion sin imagen
                      if (imagen == null) {
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
                          SmartDialog.showToast("Ocurrio un error");
                        }
                        //Agregar publicacion con imagen
                      } else {
                        final file = File(imagen!.path);

                        final metadata =
                            SettableMetadata(contentType: "image/jpeg");

                        final storageRef =
                            FirebaseStorage.instance.ref("/post");

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
                          SmartDialog.showToast("Ocurrio un error");
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Publicar',
                  ),
                )
              : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  onPressed: () {
                    SmartDialog.showToast("Ingresa una imagen o un texto");
                  },
                  child: const Text("Publicar"),
                ),
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
                        onChanged: (_) {
                          updateButtonState();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    imagen != null
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
                                  child: Image.file(imagen!, fit: BoxFit.cover),
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
                                        imagen = null;
                                        updateButtonState();
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
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 45,
          color: AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: AppColors.white,
                onPressed: _getImageCamera,
                icon: const Icon(Icons.camera_alt),
              ),
              IconButton(
                color: AppColors.white,
                onPressed: _getImageGallery,
                icon: const Icon(Icons.photo),
              ),
            ],
          ),
        ),
      ),
    );
  }

//subir imagen desde la galeria
  Future<void> _getImageGallery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture == null) {
      return;
    }
    setState(() {
      imagen = File(picture!.path);
      url = picture.name;
      updateButtonState();
    });
  }

//subir imagen desde la camara
  Future<void> _getImageCamera() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture == null) {
      return;
    }
    setState(() {
      imagen = File(picture!.path);
      url = picture.name;
      updateButtonState();
    });
  }

//funcion para el estado del boton
  void updateButtonState() {
    setState(() {
      isButtonEnabled = _textoController.text.isNotEmpty || imagen != null;
    });
  }
}
