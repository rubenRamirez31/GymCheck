import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

import 'package:gym_check/src/screens/social/create_post_page.dart';
import 'package:gym_check/src/screens/social/edit_post_page.dart';
import 'package:gym_check/src/screens/social/feed_page.dart';
import 'package:gym_check/src/screens/social/profile_page.dart';
import 'package:gym_check/src/screens/user/mi_espacio/mi_espacio_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/altura_page.dart';

import 'package:gym_check/src/screens/user/primero_pasos/edad_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/first_photo_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/general_data_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/peso_page.dart';
import 'package:gym_check/src/screens/user/primero_pasos/recomerdar_premium_page.dart';
import 'package:gym_check/src/services/loca_notification.dart';
import 'package:gym_check/src/services/push_notification.dart';
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
  await PushNotificationService.initializeApp();
  await LocalNotification.inicializeLocalNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        ChangeNotifierProvider(create: (_) => GlobalVariablesProvider()),
        ChangeNotifierProvider(create: (_) => Globales())
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          home: user != null
              ? PrincipalPage(
                  uid: user?.uid,
                )
              : const LoginPage(),
          routes: {
            // Rutas de autenticación
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/confirm_email': (context) => ConfirmEmailPage(),

            // Rutas de primeros pasos del usuario
            '/general_data': (context) => const GeneralDataPage(),
            '/edad': (context) => const EdadPage(),
            '/peso': (context) => const PesoPage(),
            '/altura': (context) => const AlturaPage(),
            '/first_photo': (context) => const FirstPhotoPage(),

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

            // Rutas para el módulo de "mi espacio"
            'mi-espacio': (context) => MiEspacioPage(),
          },
        ),
      ),
    );
  }
}
