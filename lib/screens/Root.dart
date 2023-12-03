import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      initState: (_) {
        Get.put(UserController());
      },
      builder: (_) {
        if (Get.find<UserController>().user.name != null) {
          return const Homescreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
