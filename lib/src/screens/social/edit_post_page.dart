import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPostPage extends StatefulWidget {
  final String postId;

  const EditPostPage({Key? key, required this.postId});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController _textoController = TextEditingController();

  File? _image;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

Future<void> _loadPostData() async {
  try {
    final List<Post> posts = await ApiService.getPostsByID(widget.postId);
    if (posts.isNotEmpty) {
      final Post post = posts[0]; // Obtener el primer elemento de la lista
      setState(() {
       
        _textoController.text = post.texto;
      });
    }
  } catch (error) {
    print('Error al cargar los datos de la publicación: $error');
  }
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
  Future<void> _editPost() async {
  try {
    if (_textoController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor ingrese un texto para la publicación.'),
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

    String userId = Provider.of<UserSessionProvider>(context, listen: false)
        .userSession!
        .userId;
    String _nick = ''; // Deberías obtener el nick del usuario aquí
    
    final Post editedPost = Post(
      userId: userId,
      lugar: "",
      texto: _textoController.text,
      nick: _nick,
      imagen: _image,
      editad: true,
      id: widget.postId, // Usar el ID proporcionado por el widget
    );

    await ApiService.editarPublicacion(widget.postId, editedPost);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éxito'),
        content: const Text('La publicación se ha editado exitosamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Regresar a la página anterior
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } catch (error) {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Ocurrió un error al editar la publicación: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
        title: const Text('Actualizar reporte'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),
            TextFormField(
              controller: _textoController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Texto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageCamera,
              child: const Text('Tomar una foto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageGallery,
              child: const Text('Subir una foto desde la galería'),
            ),
            const SizedBox(height: 20),
            if (_image != null) Image.file(_image!),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _editPost,
                child: const Text('Editar Publicación'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
