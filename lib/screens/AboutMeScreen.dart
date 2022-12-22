import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/models/UserModel.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:get/get.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({Key? key}) : super(key: key);
  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    UserModel currentUser = userController.user;
    return Scaffold(
      appBar: HildegundisAppBar(
        appBar: AppBar(),
        title: const Text(ProjectConfig.TextAppBarAboutMe),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 30.0,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(currentUser.avatar != null
                ? currentUser.avatar!
                : 'https://picsum.photos/200/300'),
            radius: 80.0,
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextDisplayField(
            prefixIcon: Icons.people,
            readonly: true,
            text: currentUser.name,
          ),
          TextDisplayField(
            prefixIcon: Icons.mail,
            readonly: true,
            text: currentUser.email,
          ),
        ],
      ),
    );
  }
}
