import 'package:flutter/material.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/profile/other_profile_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class FollowersPage extends StatefulWidget {
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Seguidores', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xff0C1C2E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: StreamBuilder<List<String>>(
        stream: UserService.getFollowers(globales.idDocumento),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> followersIds = snapshot.data!;
            return ListView.builder(
              itemCount: followersIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Usuario>(
                  future: UserService.getUserById(followersIds[index]),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
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
        onTap: (){
        Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherProfilePage(userNick: user.nick??"meendy"),
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
                  '${user.followers?.length ?? 0} seguidores',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FutureBuilder<bool>(
                  future: UserService.isFollowing(currentUserId, user.docId!),
                  builder: (context, snapshot) {
                    bool isFollowing = snapshot.data ?? false;
                    return IconButton(
                      onPressed: () async {
                        if (isFollowing) {
                          await UserService.unfollowUser(currentUserId, user.docId!);
                        } else {
                          await UserService.followUser(currentUserId, user.docId!);
                        }
                        setState(() {}); // To refresh the UI
                      },
                      icon: Icon(
                        isFollowing ? Icons.check_circle : Icons.add_circle,
                        color: isFollowing ? Colors.green : Colors.grey,
                      ),
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
