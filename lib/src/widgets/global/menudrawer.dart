import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    final globales = context.watch<Globales>();
    return Drawer(
        child: Column(
      children: [
        GradientBackground(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(globales.fotoPerfil),
                  ),
                ),
              ],
            ),
            Text(
              "${globales.primerNombre} ${globales.segundoNombre} Luna Santos",
              style: const TextStyle(fontSize: 24, color: AppColors.white),
            ),
            Text("@${globales.nick}", style: AppTheme.bodySmall),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          SmartDialog.showToast("Menu de usuario");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Mi perfil",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onLongPress: () {
                  SmartDialog.showLoading(msg: "Cerrando sesión");
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/login", (route) => false);
                  SmartDialog.dismiss();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Cerrar Sesión",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
