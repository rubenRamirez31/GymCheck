import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/api_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/bottom_navigation_menu.dart';
import 'package:gym_check/src/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textoController = TextEditingController();
 
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
            title: Text('Error'),
            content: Text('Por favor ingrese un texto para la publicación.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
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
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Crear Publicacion'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20),
            TextFormField(
              controller: _textoController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Texto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageCamera,
              child: Text('Tomar una foto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageGallery,
              child: Text('Subir una foto desde la galeria'),
            ),
            SizedBox(height: 20),
            if (_image != null) Image.file(_image!),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _createPost,
                child: Text('Crear Publicación'),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
