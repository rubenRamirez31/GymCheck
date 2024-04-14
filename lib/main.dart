import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/authentication/confirm_email_page.dart';
import 'package:gym_check/src/screens/authentication/login_page.dart';
import 'package:gym_check/src/screens/authentication/register_page.dart';
import 'package:gym_check/src/screens/crear/create_page.dart';
import 'package:gym_check/src/screens/crear/ejercicios/create_exercise_page.dart';
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
  runApp(
    const MyApp(),
  );
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
      child: MaterialApp(
        title: 'Your App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        initialRoute: '/',
        routes: {
          //Paginas de autenticacion
          '/': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/confirm_email': (context) => ConfirmEmailPage(),

          //Paginas de usuario primeros pasos
          '/general_data': (context) => GeneralDataPage(),
          '/first_photo': (context) => FirstPhotoPage(),
          '/body_data': (context) => BodyDataPage(),
          '/nutritional_data': (context) => NutritionalDataPage(),
          '/emotional_data': (context) => EmotionalDataPage(),
          '/recomendar_premium': (context) => RecomendarPlanPremiumPage(),

          //Paginas del modulo social
          '/feed': (context) => FeedPage(),
          '/commentbox': (context) => CommentBox(),
          '/share': (context) => Share(),
          '/profile': (context) => ProfilePage(nick: ""),
          '/create-post': (context) => CreatePostPage(),
          '/edit-post': (context) => const EditPostPage(postId: ""),

          //Paginas para el modulo de creacion
          'create-module': (context) => CreatePage(),
          '/create-excersice': (context) => const CreateExercisePage(),

          //Paginas para le modulo de seguimiento

          'seguimiento-fisico': (context) => PhysicalTrackingPage(),

          //Paginas para el modulo de mi espacio

          'mi-espacio': (context) => MiEspacioPage(),

          //'/home': (context) => HomePage(),
        },
      ),
    );
  }
}
