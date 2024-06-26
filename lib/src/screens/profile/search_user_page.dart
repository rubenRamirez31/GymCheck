import 'package:flutter/material.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/profile/other_profile_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  Stream<List<Usuario>>? _searchResultsStream;

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResultsStream =
            UserService.obtenerUsuariosFiltradosStream(query);
      });
    } else {
      setState(() {
        _searchResultsStream = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();

    return Scaffold(
     appBar: AppBar(
        title: Text(
          'Buscar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0C1C2E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hoverColor: Colors.white,
                //fillColor: Colors.white,
                iconColor: Colors.white,
                focusColor: Colors.white,
                hintText: 'Buscar por nickname...',
                border: OutlineInputBorder(),
               suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: const Icon(Icons.clear, color: Colors.white,),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _searchResultsStream != null
                ? StreamBuilder<List<Usuario>>(
                    stream: _searchResultsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Usuario> usuarios = snapshot.data!;
                        return ListView.builder(
                          itemCount: usuarios.length,
                          itemBuilder: (context, index) {
                            return _buildUserCard(
                                usuarios[index], globales.idDocumento);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : Center(child: Text('')),
          ),
        ],
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
                          await UserService.unfollowUser(
                              currentUserId, user.docId!);
                        } else {
                          await UserService.followUser(
                              currentUserId, user.docId!);
                        }
                        setState(() {}); // Para refrescar la UI
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
