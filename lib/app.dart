import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hildegundis_app_new/controller/BottomNavigationBarController.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HildegundisAPP extends StatelessWidget {
  HildegundisAPP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: InitialBindings(),
        initialRoute: "/",
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('de'), const Locale('us')],
        locale: const Locale('de'),
        theme: ThemeData(
          textTheme: GoogleFonts.yanoneKaffeesatzTextTheme(
              Theme.of(context).textTheme),
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: <String, WidgetBuilder>{
          'loginScreen': (BuildContext context) => LoginScreen(),
          'homeScreen': (BuildContext context) => Homescreen()
        },
        home: const AuthScreen());
  }
}

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<BottomNavigationBarController>(
        () => BottomNavigationBarController());
  }
}
