import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/providers/global_variables_provider.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/screens/authentication/confirm_email_page.dart';
import 'package:gym_check/src/screens/authentication/login_page.dart';
import 'package:gym_check/src/screens/authentication/register_page.dart';
import 'package:gym_check/src/screens/crear/create_page.dart';
import 'package:gym_check/src/screens/principal.dart';
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
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        ChangeNotifierProvider(create: (_) => GlobalVariablesProvider()),
        ChangeNotifierProvider(create: (_) => Globales())
      ],
      child: CalendarControllerProvider(
        controller: EventController(), // Aquí asignamos un EventController
        child: MaterialApp(
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          initialRoute: '/',
          routes: {
            // Rutas de autenticación
            '/': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/confirm_email': (context) => ConfirmEmailPage(),

            // Rutas de primeros pasos del usuario
            '/general_data': (context) => const GeneralDataPage(),
            '/first_photo': (context) => const FirstPhotoPage(),
            '/body_data': (context) => const BodyDataPage(),
            '/nutritional_data': (context) => const NutritionalDataPage(),
            '/emotional_data': (context) => const EmotionalDataPage(),
            '/recomendar_premium': (context) =>
                const RecomendarPlanPremiumPage(),

            //principal
            '/principal': (context) => const PrincipalPage(),

            //Paginas del modulo social
            '/feed': (context) => const FeedPage(),
            '/commentbox': (context) => const CommentBox(),
            '/share': (context) => const Share(),
            '/profile': (context) => ProfilePage(nick: ""),
            '/create-post': (context) => const CreatePostPage(),
            '/edit-post': (context) => const EditPostPage(postId: ""),

            // Rutas para el módulo de creación
            'create-module': (context) => CreatePage(),

            // Rutas para el módulo de seguimiento
            'seguimiento-fisico': (context) => const PhysicalTrackingPage(),

            // Rutas para el módulo de "mi espacio"
            'mi-espacio': (context) => MiEspacioPage(),
          },
        ),
      ),
    );
  }
}
