import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/profile/edit_profile_page.dart';
import 'package:gym_check/src/screens/profile/followers_page.dart';
import 'package:gym_check/src/screens/profile/following_page.dart';
import 'package:gym_check/src/screens/profile/other_profile_page.dart';
import 'package:gym_check/src/screens/qr/gr_scanner.dart';
import 'package:gym_check/src/screens/qr/qr_generator.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_user_page.dart';

class ProfilePage extends StatefulWidget {
  final Function? openDrawer;
  final int? initialPageIndex;
  final int? initialSubPageMenuIndex;

  const ProfilePage({
    super.key,
    this.openDrawer,
    this.initialPageIndex,
    this.initialSubPageMenuIndex,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  List<String> options = ['Rutinas', 'Series', 'Recetas'];
  List<Color> highlightColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  List<IconData> myIcons = [Icons.create, Icons.save, Icons.restaurant];
  int _selectedMenuOption = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedMenuOption();
  }

  Future<void> _loadSelectedMenuOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMenuOption = widget.initialPageIndex ??
          prefs.getInt('selectedSubPageProfile') ??
          0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var globalVariable = Provider.of<GlobalVariablesProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            leading: GestureDetector(
              onTap: () {
                widget.openDrawer!();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xff0C1C2E),
            title: const Text(
              'Life check',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchUserPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                onPressed: () {
                  showModalBottomSheet(
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
                        child: QRScanner(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _cardProfile(context),
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  _selectedMenuOption = index;
                                  globalVariable.selectedSubPageProfile =
                                      _selectedMenuOption;
                                });
                                await prefs.setInt(
                                    'selectedSubPageProfile', index);
                              },
                              selectedMenuOptionGlobal:
                                  widget.initialPageIndex ??
                                      globalVariable.selectedSubPageProfile,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _selectedMenuOption == 0
                      ? const SizedBox()
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardProfile(BuildContext contex) {
    final globales = context.watch<Globales>();

    return Container(
      decoration: BoxDecoration(
        //color: Color.fromARGB(125, 120, 120, 120),
        borderRadius: BorderRadius.circular(10), // Radio de los bordes redondos
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
                      backgroundImage: NetworkImage(globales.fotoPerfil),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        globales.nick,
                        style: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowersPage(),
                              ),
                            );
                          },
                          child: StreamBuilder<List<String>>(
                            stream: globales.idDocumento.isNotEmpty
                                ? UserService.getFollowers(globales.idDocumento)
                                : Stream.value([]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  "${snapshot.data!.length} seguidores",
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                              return Text(
                                "0 seguidores",
                                style: TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 5),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowingPage(),
                              ),
                            );
                          },
                          child: StreamBuilder<List<String>>(
                            stream: globales.idDocumento.isNotEmpty
                                ? UserService.getFollowing(globales.idDocumento)
                                : Stream.value([]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  "°   ${snapshot.data!.length} Siguiendo",
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                              return Text(
                                "°   0 Siguiendo",
                                style: TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        globales.estado ?? "Sin estado",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                },
                text: "Editar",
                icon: Icons.settings,
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                iconColor: Colors.white,
                borderColor: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  _menuProfile(globales.nick);
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _menuProfile(String nombre) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.qr_code_2, color: Colors.white),
                title: Text('Compartir perfil',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  showModalBottomSheet(
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
                          child: QRGenerator(
                            tipoDocumento: "Usuario",
                            claveDocumento: nombre,
                          ));
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.remove_red_eye, color: Colors.white),
                title: Text('Vista previa de mi perfil',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherProfilePage(
                        userNick: nombre,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
