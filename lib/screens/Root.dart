import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart' show BuildContext, Widget;
import 'package:get/get.dart';
import 'package:hildegundis_app_new/screens/Homescreen.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      initState: (_) {
        Get.put(UserController());
      },
      builder: (_) {
        if (Get.find<UserController>().user.name != null) {
          return Homescreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
