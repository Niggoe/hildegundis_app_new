import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:overlay_support/overlay_support.dart';

class HildegundisAPP extends StatelessWidget {
  HildegundisAPP({Key? key}) : super(key: key);
  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body);

        showSimpleNotification(
          Text(notification.title!),
          subtitle: Text(notification.body!),
          background: Colors.cyan.shade700,
          duration: const Duration(seconds: 3),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      });
    } else {
      print('User declined permission');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  @override
  Widget build(BuildContext context) {
    registerNotification();
    checkForInitialMessage();
    return OverlaySupport(
        child: GetMaterialApp(
            initialBinding: InitialBindings(),
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale('de'), Locale('us')],
            locale: const Locale('de'),
            theme: ThemeData(
              textTheme: GoogleFonts.yanoneKaffeesatzTextTheme(
                  Theme.of(context).textTheme),
              primarySwatch: Colors.indigo,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routes: <String, WidgetBuilder>{
              'loginScreen': (BuildContext context) => const LoginScreen(),
              'homeScreen': (BuildContext context) => const Homescreen()
            },
            home: const AuthScreen()));
  }
}

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<UserController>(UserController());
    Get.put<BottomNavigationBarController>(BottomNavigationBarController());
  }
}
