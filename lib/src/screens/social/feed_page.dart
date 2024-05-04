import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/social/menuperfil.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/widgets/social/post_widget.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:provider/provider.dart';

// Importa la página de creación de publicaciones
import 'create_post_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> postStream =
        FirebaseFirestore.instance.collection("Publicaciones").snapshots();
    final globales = context.watch<Globales>();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const FractionallySizedBox(
                      heightFactor: 0.30,
                      child: MenuPerfil(),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(globales.fotoPerfil),
                ),
              ),
            ),
            title: const Text(
              'LifeCheck',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            backgroundColor: AppColors.darkBlue,
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
          StreamBuilder<QuerySnapshot>(
            stream: postStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              } else {
                final docs = snapshot.data!.docs;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = docs[index];
                      final postData = post.data() as Map<String, dynamic>;
                      final p = Post.getFirebaseId(post.id, postData);
                      return PostWidget(post: p);
                    },
                    childCount: docs.length,
                  ),
                );
              }
            },
          )
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
