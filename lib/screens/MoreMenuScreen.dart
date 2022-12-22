import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/AuthController.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:get/get.dart';

class MoreMenuScreen extends StatefulWidget {
  const MoreMenuScreen({Key? key}) : super(key: key);
  @override
  _MoreMenuScreenState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final List<MenuData> menu = [
      MenuData(Icons.person, ProjectConfig.BNAboutMe, const AboutMeScreen()),
      MenuData(Icons.important_devices, 'Impressum', const ImpressumScreen()),
    ];

    return Scaffold(
        appBar: HildegundisAppBar(
            appBar: AppBar(), title: Text("More menu"), widgets: []),
        body: Container(
            child: Scrollbar(
                thickness: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: menu.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 0.2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => menu[index].widgetToOpen);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      menu[index].icon,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      menu[index].title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black87),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50)),
                            child: const Text(ProjectConfig.BNLogutMenu),
                            onPressed: () {
                              AuthController().signOut();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ))));
  }
}

class MenuData {
  MenuData(this.icon, this.title, this.widgetToOpen);
  final IconData icon;
  final String title;
  final Widget widgetToOpen;
}
