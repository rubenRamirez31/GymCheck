import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gym_check/src/services/loca_notification.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  //Funcion maestra que se invocara en el main
  static Future initializeApp() async {
    //push notificacions
    await Firebase.initializeApp();

    requestPermission();

    //manejar las notificaciones

    //Cuando la aplicacion esta funcionando en primer planop
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
    print("Servicio de notificaciones en primero plano");

    //Cuando la aplicacion esta en segundo plano
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  //pedir permisos al dispositivo
  static void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);

    //Agregar la requisision de permisos
    await LocalNotification.requestPermisionLocalNotifications();

    //obtener estatus
    settings.authorizationStatus;

    print('User granted permission: ${settings.authorizationStatus}');
    getToken();
  }

  //Obtener token
  static void getToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    token = await FirebaseMessaging.instance.getToken();
    print('token de dispositivo: ${token}');
  }

/*   static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    Random random = Random();
    var id = random.nextInt(100000);
    var title = message.notification?.title;
    var body = message.notification?.body;
    print("segundo plano handler ${message.messageId}");
    LocalNotification.showLocalNotification(id: id, title: title, body: body);
  } */
  static Future _backgroundHandler(RemoteMessage message) async {
    print('mensaje en segundo plano ${message.messageId}');
  }

  static void handleRemoteMessage(RemoteMessage message) {
    Random random = Random();
    var id = random.nextInt(100000);
    var title = message.notification?.title;
    var body = message.notification?.body;

    LocalNotification.showLocalNotification(id: id, title: title, body: body);
    print("Primer plano handler ${message.messageId}");
  }
}
