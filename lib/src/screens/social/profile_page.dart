import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart'; // Importa el modelo de Post
import 'package:gym_check/src/services/api_service.dart'; // Importa el servicio API
import 'package:gym_check/src/widgets/social/post_widget.dart'; // Importa el widget de Post

class ProfilePage extends StatefulWidget {
  final String nick;

  ProfilePage({required this.nick});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> _posts = []; // Lista para almacenar las publicaciones del usuario

  @override
  void initState() {
    super.initState();
    _loadPostsByNick(); // Cargar las publicaciones al inicializar la página
  }

  // Método para cargar las publicaciones del usuario por su nick
  Future<void> _loadPostsByNick() async {
    try {
      List<Post> posts = await ApiService.getPostsByNick(widget.nick);
      setState(() {
        _posts = posts;
      });
    } catch (error) {
      print('Error al cargar las publicaciones del usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes de ${widget.nick}' ),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return PostWidget(post: _posts[index]); // Mostrar el widget de Post para cada publicación
        },
      ),
    );
  }
}
