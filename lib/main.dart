
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/authentication/confirm_email_page.dart';
import 'package:gym_check/src/screens/authentication/login_page.dart';
import 'package:gym_check/src/screens/authentication/register_page.dart';
import 'package:gym_check/src/screens/crear/create_page.dart';
import 'package:gym_check/src/screens/seguimiento/physical/physical_tracking_page.dart';

import 'package:gym_check/src/screens/social/create_post_page.dart';
import 'package:gym_check/src/screens/social/edit_post_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/screens/social/profile_page.dart';
import 'package:gym_check/src/screens/user/mi_espacio/mi_espacio_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/body_data_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/emotional_data_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/first_photo_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/general_data_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/nutritional_data_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/recomerdar_premium_page.dart';
import 'package:gym_check/src/values/app_theme.dart';
import 'package:gym_check/src/widgets/social/comment_box.dart';
import 'package:gym_check/src/widgets/social/share_box.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        ChangeNotifierProvider(create: (_) => GlobalVariablesProvider()),
      ],
      child: CalendarControllerProvider(
        controller: EventController(), // Aquí asignamos un EventController
        child: MaterialApp(
           title: 'Your App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
    
          initialRoute: '/',
          routes: {
            // Rutas de autenticación
            '/': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/confirm_email': (context) => ConfirmEmailPage(),

            // Rutas de primeros pasos del usuario
            '/general_data': (context) => GeneralDataPage(),
            '/first_photo': (context) => FirstPhotoPage(),
            '/body_data': (context) => BodyDataPage(),
            '/nutritional_data': (context) => NutritionalDataPage(),
            '/emotional_data': (context) => EmotionalDataPage(),
            '/recomendar_premium': (context) => RecomendarPlanPremiumPage(),

            //Paginas del modulo social
          '/feed': (context) => const FeedPage(),
          '/commentbox': (context) => CommentBox(),
          '/share': (context) => Share(),
          '/profile': (context) => ProfilePage(nick: ""),
          '/create-post': (context) => CreatePostPage(),
          '/edit-post': (context) => const EditPostPage(postId: ""),

            // Rutas para el módulo de creación
            'create-module': (context) => CreatePage(),

            // Rutas para el módulo de seguimiento
            'seguimiento-fisico':(context) => PhysicalTrackingPage(),

            // Rutas para el módulo de "mi espacio"
            'mi-espacio':(context) => MiEspacioPage(),
          },
        ),
      ),
    );
  }
}
