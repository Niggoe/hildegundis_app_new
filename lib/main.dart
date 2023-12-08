import 'package:flutter/material.dart';
import 'package:flutter_fcm/flutter_fcm.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/controller/UserController.dart';

import 'app.dart';
import 'controller/AuthController.dart';
import 'controller/BottomNavigationBarController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(BottomNavigationBarController());
  });
  runApp(HildegundisAPP());
}
