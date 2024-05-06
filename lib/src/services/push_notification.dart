import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print("onBackground handler ${message.messageId}");
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print("onMessage handler ${message.messageId}");
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print("onMessageOpenApp handler ${message.messageId}");
  }

  static Future initializeApp() async {
    //push notificacions
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    //Handlers

    //Cuando la aplicacion esta destruida
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);

    //Cuando la aplicacion esta funcionando en segundo plano
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    //Cuando la aplicacion esta funcionando en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }
}
