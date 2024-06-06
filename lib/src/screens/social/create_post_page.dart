// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/social/ver_rutinas.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/social/rutina_cardCreatePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tflite_v2/tflite_v2.dart';

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
  String resultados = "";
  String label = "";
  double confianza = 0;
  String idRutina = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
    if (globales.rutinas.isNotEmpty) {
      for (Workout workout in globales.rutinas) {
        setState(() {
          idRutina = workout.id!;
        });
      }

      print(idRutina);
    }

    return PopScope(
        canPop: false,
        onPopInvoked: ((didPop) {
          if (didPop) {
            return;
          }
          _showBackDialog();
        }),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.darkBlue,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: AppColors.white,
              ), // Icono de una equis
              onPressed: () {
                _showBackDialog();
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
                                  idRutina: idRutina);

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
                            if (label == "1 nonude" && confianza == 1) {
                              final file = File(imagen!.path);

                              final metadata =
                                  SettableMetadata(contentType: "image/jpeg");

                              final storageRef =
                                  FirebaseStorage.instance.ref("/post");

                              SmartDialog.showLoading(msg: "Publicando");

                              try {
                                final uploadTask = storageRef
                                    .child(url)
                                    .putFile(file, metadata);
                                await uploadTask.whenComplete(() => null);

                                // Obtener la URL de descarga después de que la carga sea exitosa
                                link = await storageRef
                                    .child(url)
                                    .getDownloadURL();

                                Post newPost = Post(
                                    userId: globales.idAuth,
                                    texto: _textoController.text,
                                    nick: globales.nick,
                                    lugar: "",
                                    fechaCreacion: DateTime.now(),
                                    urlImagen: link,
                                    editad: false,
                                    idRutina: idRutina);

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
                            } else {
                              SmartDialog.showToast("Eliga otra imagen");
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
                          child: globales.fotoPerfil != null &&
                                  globales.fotoPerfil != ""
                              ? FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: globales.fotoPerfil,
                                )
                              : const Icon(
                                  Icons.person,
                                  size:
                                      30, // Puedes ajustar el tamaño según tus necesidades
                                ),
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
                        globales.rutinas.isNotEmpty
                            ? RutinaCardCreatePage(workout: globales.rutinas[0])
                            : Container(),
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
                                      child: Image.file(imagen!,
                                          fit: BoxFit.cover),
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
                  IconButton(
                    color: AppColors.white,
                    onPressed: () {
                      showModalBottomSheet(
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
                            heightFactor: 0.93,
                            child: VerRutinas(nick: globales.nick),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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
    prediction(imagen!);
  }

//subir imagen desde la camara
  Future<void> _getImageCamera() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picture == null) {
      return;
    }
    setState(() {
      imagen = File(picture!.path);
      url = picture.name;
      updateButtonState();
    });
    prediction(imagen!);
  }

//funcion para el estado del boton
  void updateButtonState() {
    setState(() {
      isButtonEnabled = _textoController.text.isNotEmpty || imagen != null;
    });
  }

  void _showBackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Desea salir?'),
          content: const Text(
              'Si sale de esta pantalla se eliminara lo que estaba haciendo'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final globales = context.watch<Globales>();
                globales.quitarRutina();
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Continuar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/tf/model_unquant.tflite",
        labels: "assets/tf/labels.txt");
  }

  Future prediction(File imagen) async {
    try {
      var reconocimiento = await Tflite.runModelOnImage(path: imagen.path);

      for (var elemento in reconocimiento!) {
        setState(() {});

        label = elemento['label'];
        confianza = elemento['confidence'];
        resultados = 'Label: $label, Confianza: $confianza';

        if (label == '0 nude' && confianza > .9) {
          // Aquí puedes poner el código para mostrar la advertencia

          SmartDialog.showToast(
              'Advertencia: No se pueden subir ese tipo de imágenes');
        }

        if (label == "1 nonude" && confianza < 1) {
          SmartDialog.showToast(
              'Advertencia: No se pueden subir ese tipo de imágenes');
        }
      }
    } catch (e) {
      resultados = "Ha ocurrido un error";
    }
  }
}
