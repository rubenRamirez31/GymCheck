import 'package:flutter/material.dart';

class MenuPerfil extends StatefulWidget {
  const MenuPerfil({super.key});

  @override
  State<MenuPerfil> createState() => _MenuPerfilState();
}

class _MenuPerfilState extends State<MenuPerfil> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [Icon(Icons.person)],
        ),
        Row(
          children: [Icon(Icons.logout)],
        )
      ],
    );
  }
}
