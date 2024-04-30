import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImageUrl;
  final VoidCallback? onProfilePressed;
  final List<Widget>? actions; // Lista de botones adicionales
  final List<Widget>? trackingOptions; // Lista de opciones de seguimiento

  CustomAppBar({
    required this.title,
    this.profileImageUrl,
    this.onProfilePressed,
    this.actions,
    this.trackingOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text(title),
          backgroundColor:
              Color.fromARGB(255, 227, 227, 227), // Color del AppBar
          leading: GestureDetector(
            onTap: () {
              _showProfileMenu(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(
                  8.0), // Añadir un poco de espacio alrededor de la imagen de perfil
              child: CircleAvatar(
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                backgroundColor: Colors.amber,
              ),
            ),
          ),
          actions: <Widget>[
            if (actions != null) ...actions!, // Agregar botones adicionales
          ],
        ),
        if (trackingOptions != null)
          Row(
            children: trackingOptions!,
          ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (trackingOptions?.length ?? 0) * 40.0);

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Mi perfil'),
                onTap: () {
                  // Aquí puedes navegar a la pantalla de perfil o realizar alguna acción específica
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración'),
                onTap: () {
                  // Aquí puedes navegar a la pantalla de configuración o realizar alguna acción específica
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Cerrar sesión'),
                onTap: () {
                  // Aquí puedes realizar la lógica para cerrar sesión
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

