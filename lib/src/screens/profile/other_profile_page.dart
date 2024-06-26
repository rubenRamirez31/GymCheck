import 'package:flutter/material.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/profile/followers_page.dart';
import 'package:gym_check/src/screens/profile/following_page.dart';
import 'package:gym_check/src/screens/profile/search_user_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';

class OtherProfilePage extends StatefulWidget {
  final String userNick;

  const OtherProfilePage({Key? key, required this.userNick}) : super(key: key);

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  Usuario? usuario;
  bool isFollowing = false;

   List<String> options = [
    'Rutinas',
    'Series',
    'Alimentos',
  ]; // Lista de opciones

  List<Color> highlightColors = [
    Colors.white, // Color de resaltado para 'Fisico'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Nutricional'
  ];

  List<IconData> myIcons = [
    Icons.sports_gymnastics,
    Icons.playlist_add_check,
    Icons.food_bank,
  ];
  int _selectedMenuOption = 0;


  @override
  void initState() {
    super.initState();
    _loadUserAndCheckFollowing();
  }

  Future<void> _loadUserAndCheckFollowing() async {
    try {
      Usuario? user = await UserService.getUserByNick(widget.userNick);
      if (user != null) {
        setState(() {
          usuario = user;
        });
        await _checkIfFollowing(
            user.docId!); // Corregir user.idAuth a user.docId
      } else {
        print('Usuario no encontrado.');
      }
    } catch (e) {
      print('Error al cargar el usuario: $e');
    }
  }

  Future<void> _checkIfFollowing(String userId) async {
    String currentUserDocId = await UserService.getCurrentUserDocId();
    bool following = await UserService.isFollowing(currentUserDocId, userId);
    setState(() {
      isFollowing = following;
    });
  }

  Future<void> _followOrUnfollow() async {
    try {
      String currentUserDocId = await UserService.getCurrentUserDocId();
      if (isFollowing) {
        await UserService.unfollowUser(currentUserDocId, usuario!.docId!);
      } else {
        await UserService.followUser(currentUserDocId, usuario!.docId!);
      }
      setState(() {
        isFollowing = !isFollowing;
      });
    } catch (e) {
      print('Error en seguir/dejar de seguir: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: const Color(0xff0C1C2E),
         actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
//              void _showViewData(BuildContext context, String data) {
            /*  showModalBottomSheet(
                showDragHandle: true,
                backgroundColor: const Color.fromARGB(255, 18, 18, 18),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.90,
                    child: SearchUserPage(),
                  );
                },
              );*/
              //}
              Navigator.push(
                context,
                MaterialPageRoute(
                   builder: (context) => SearchUserPage(),
                 // builder: (context) => OtherProfilePage(userNick: "morris"),
                ),
              );
            },
          ),
         ]
       
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: usuario == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(126, 18, 18, 18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                         NetworkImage(usuario!.fotoPerfil!),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        usuario!.nick!,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowersPage(),
                                            ),
                                          );
                                        },
                                        child: StreamBuilder<List<String>>(
                                          stream: UserService.getFollowers(
                                              usuario!.docId!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                "${snapshot.data!.length} seguidores",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                            return Text(
                                              "0 seguidores",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowingPage(),
                                            ),
                                          );
                                        },
                                        child: StreamBuilder<List<String>>(
                                          stream: UserService.getFollowing(
                                              usuario!.docId!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                "°  ${snapshot.data!.length} seguidos",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                            return Text(
                                              "°  0 seguidos",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomButton(
                                onPressed: _followOrUnfollow,
                                text: 
                                  isFollowing ? 'Dejar de seguir' : 'Seguir',
                                  icon:  isFollowing ? Icons.check_circle : Icons.add_circle,
                                
                              ),
                               IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert_outlined,
                            color: Colors.white,
                          ),
                        ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
              Container(
                color: const Color.fromARGB(255, 18, 18, 18),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        MenuButtonOption(
                          options: options,
                          icons: myIcons,
                          onItemSelected: (index) async {

                            
                            setState(() {
                              _selectedMenuOption = index;
                            
                            });
                           // await prefs.setInt('selectedSubPageProfile', index);
                          },
                          selectedMenuOptionGlobal: _selectedMenuOption
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                  ],
                ),
              ),
            ),
    );
  }
}
