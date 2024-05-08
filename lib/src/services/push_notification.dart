import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print("segundo plano handler ${message.messageId}");
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print("aplicacion destruida onMessageOpenApp handler ${message.messageId}");
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

    settings.authorizationStatus;

    print('User granted permission: ${settings.authorizationStatus}');

    getToken();
  }

  //handlelocalremotemessage
/*   static void _handeRemoteMenssage(RemoteMessage message) {
    var mensaje = message.data;
    var title = mensaje['title'];
    var body = mensaje['body'];
  } */

  //Obtener token
  static void getToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    token = await FirebaseMessaging.instance.getToken();
    print('token de dispositivo: ${token}');
  }

//Metodo para recibir el mensaje en primer plano
  static Future _onMessageHandler(RemoteMessage message) async {
    var mensaje = message.data;
    var title = mensaje['title'];
    var body = mensaje['body'];
    print("primer plano handler ${message.messageId}");
    print("onMessage handler ${title}");
    print("onMessage handler ${body}");
  }

//Funcion maestra que se invocara en el main
  static Future initializeApp() async {
    //push notificacions
    await Firebase.initializeApp();

    requestPermission();

    //manejar las notificaciones

    //Cuando la aplicacion esta funcionando en primer planop
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    print("Servicio de notificaciones en primero plano");

    //Cuando la aplicacion esta en segundo plano
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    print("Servicio de notificaciones en segundo plano");

    //Cuando la aplicacion esta destruida
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    print("Servicio de notificaciones con la app destruida");
  }
}
