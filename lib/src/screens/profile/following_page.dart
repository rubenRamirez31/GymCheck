import 'package:flutter/material.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/profile/other_profile_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Siguiendo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0C1C2E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: StreamBuilder<List<String>>(
        stream: UserService.getFollowing(globales.idDocumento),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> followingIds = snapshot.data!;
            return ListView.builder(
              itemCount: followingIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Usuario>(
                  future: UserService.getUserById(followingIds[index]),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    }
                    Usuario? user = userSnapshot.data;
                    if (user == null) {
                      return SizedBox.shrink();
                    }
                    return _buildUserCard(user, globales.idDocumento);
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildUserCard(Usuario user, String currentUserId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtherProfilePage(userNick: user.nick ?? "meendy"),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(126, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.fotoPerfil ?? ''),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nick ?? '',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  '${user.followers?.length ?? 0} followers',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    bool isFollowing =
                        false; // Estado local para verificar si se sigue o no
                    return FutureBuilder<bool>(
                      future:
                          UserService.isFollowing(currentUserId, user.docId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          isFollowing = snapshot.data!;
                        }
                        return IconButton(
                          onPressed: () async {
                            if (isFollowing) {
                              isFollowing = false;
                              //  await UserService.unfollowUser(currentUserId, user.docId!);
                            } else {
                              await UserService.followUser(
                                  currentUserId, user.docId!);
                            }
                            setState(
                                () {}); // Refresca el estado local del botón
                          },
                          icon: Icon(
                            isFollowing ? Icons.check_circle : Icons.add_circle,
                            color: isFollowing ? Colors.green : Colors.grey,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
