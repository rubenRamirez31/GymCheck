import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gym_check/src/components/app_text_form_field.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/api_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textoController = TextEditingController();

  bool _isKeyboardVisible = false;

  //String _selectedLugar = 'Agregar lugar'; // Cambiado de 'Puebla' a 'Agregar lugar'
  File? _image;

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

  Future<void> _createPost() async {
    try {
      if (_textoController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Por favor ingrese un texto para la publicación.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      String _nick = '';
      String _userIdAuth = '';
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      setState(() {
        _nick = userData['nick'];
        _userIdAuth = userData['userIdAuth'];
      });
      final Post newPost = Post(
        userId: _userIdAuth,
        texto: _textoController.text,
        nick: _nick,
        fechaCreacion: DateTime.now(),
        imagen: _image,
        editad: false,
        id: "ñeñjeje",
      );

      // Enviar la publicación al servicio API
      await ApiService.crearPublicacion(newPost);
      //print("Imgen"+ imagenBase64);

      // Mostrar un mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('La publicación se ha creado exitosamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Regresar a la página anterior
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      // Manejar errores
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ocurrió un error al crear la publicación: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ), // Icono de una equis
          onPressed: () {
            // Acción al presionar el botón de la equis
            Navigator.pop(context); // Cierra la pantalla actual
          },
        ),
        actions: [
          ElevatedButton(onPressed: _createPost, child: const Text('Publicar')),
          const SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              autofocus: true,
              controller: _textoController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Comparte algo con los demas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              // Altura definida
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), // Borde redondeado
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      15), // Borde redondeado para la imagen
                  child: Image.file(_image!, fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: AppColors.darkBlue,
                    width: 1.0), // Borde superior negro
                bottom: BorderSide(
                    color: AppColors.darkBlue,
                    width: 1.0), // Borde inferior negro
              ),
            ),
            child: Container(
              height: 45,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: _getImageCamera,
                    icon: const Icon(Icons.camera_alt),
                  ),
                  IconButton(
                    onPressed: _getImageGallery,
                    icon: const Icon(Icons.photo),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
