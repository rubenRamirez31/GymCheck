import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/api_service.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/social/post_widget.dart';
import 'package:provider/provider.dart';
import 'package:gym_check/src/models/social/post_model.dart';

// Importa la página de creación de publicaciones
import 'create_post_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String _nick = '';
  String _urlImagen = '';
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPosts();
  }

  Future<void> _loadUserData() async {
    try {
      String userId = Provider.of<UserSessionProvider>(context, listen: false)
          .userSession!
          .userId;
      Map<String, dynamic> userData = await UserService.getUserData(userId);
      setState(() {
        _nick = userData['nick'];
        _urlImagen = userData['urlImagen'];
      });
    } catch (error) {
      print('Error al cargar los datos del usuario: $error');
    }
  }

  Future<void> _loadPosts() async {
    try {
      List<Post> posts = await ApiService.getAllPosts();
      setState(() {
        _posts = posts;
      });
    } catch (error) {
      print('Error al cargar las publicaciones: $error');
    }
  }

  void _onTabTapped(int index) {
    var globalVariable =
        Provider.of<GlobalVariablesProvider>(context, listen: false);

    // Aquí puedes agregar lógica para navegar a otras páginas según la pestaña seleccionada
    print('Pestaña $index seleccionada');
    switch (index) {
      case 0:
        // Navegar a la página de FeedPage
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/feed", (route) => false);
        break;
      case 1:
        // Navegar a la página de creación dependiendo su ultimo estado
        if (globalVariable.selectedSubPageCreate == 0) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/create-excersice", (route) => false);
        } else if (globalVariable.selectedSubPageCreate == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDietPage()),
          );
        }
        break;
      case 2:
        if (globalVariable.selectedSubPageTracking == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PhysicalTrackingPage()),
          );
        } else if (globalVariable.selectedSubPageTracking == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmotionalTrackingPage()),
          );
        } else if (globalVariable.selectedSubPageTracking == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NutritionalTrackingPage()),
          );
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestBlue,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'GymCheck',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.darkestBlue,
            actions: [
              IconButton(
                color: AppColors.white,
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                color: AppColors.white,
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
            floating:
                true, // Hace que el AppBar se desplace fuera de la vista al hacer scroll hacia abajo
            snap:
                true, // Hace que el AppBar se oculte completamente al hacer scroll hacia abajo
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostWidget(post: _posts[index]);
              },
              childCount: _posts.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CreatePostPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: AppColors.darkBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
