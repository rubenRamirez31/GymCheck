import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/screens/crear/widgets/custom_button.dart';
import 'package:gym_check/src/screens/profile/followers_page.dart';
import 'package:gym_check/src/screens/profile/following_page.dart';
import 'package:gym_check/src/screens/profile/other_profile_page.dart';
import 'package:gym_check/src/screens/seguimiento/productivity/daily_routine_page.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:gym_check/src/widgets/menu_button_option_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_user_page.dart'; // Importa la página de búsqueda de usuarios

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
  List<String> options = [
    'Dia a Dia',
    'Creaciones',
    'Colecciones',
  ]; // Lista de opciones

  List<Color> highlightColors = [
    Colors.white, // Color de resaltado para 'Fisico'
    Colors.white, // Color de resaltado para 'Emocional'
    Colors.white, // Color de resaltado para 'Nutricional'
  ];

  List<IconData> myIcons = [
    Icons.calendar_today,
    Icons.create,
    Icons.save,
  ];
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
    final globales = context.watch<Globales>();
    var globalVariable = Provider.of<GlobalVariablesProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
//              void _showViewData(BuildContext context, String data) {
              /* showModalBottomSheet(
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
          IconButton(
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () {
              // _showOptionsBottomSheetRegister(context);
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(126, 18, 18, 18),
                  borderRadius:
                      BorderRadius.circular(10), // Radio de los bordes redondos
                  border: Border.all(
                    color: Colors.white, // Color del borde
                    width: 0.5, // Ancho del borde
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
                                    NetworkImage(globales.fotoPerfil),
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
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                                      stream: UserService.getFollowers(
                                          globales.idDocumento),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data!.length} seguidores",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                  //Text("l"),
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
                                      stream: UserService.getFollowing(
                                          globales.idDocumento),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "°   ${snapshot.data!.length} Siguiendo",
                                            style:
                                                TextStyle(color: Colors.white),
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
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomButton(
                          onPressed: () {},
                          text: "Editar",
                          icon: Icons.settings,
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
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              _selectedMenuOption = index;
                              globalVariable.selectedSubPageProfile =
                                  _selectedMenuOption;
                            });
                            await prefs.setInt('selectedSubPageProfile', index);
                          },
                          selectedMenuOptionGlobal: widget.initialPageIndex ??
                              globalVariable.selectedSubPageProfile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _selectedMenuOption == 0
                  ? const DailyRoutinePage()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
