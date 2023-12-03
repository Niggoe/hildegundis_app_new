import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/BottomNavigationBarController.dart';
import 'package:hildegundis_app_new/screens/FormationScreenNew.dart';
import 'package:hildegundis_app_new/screens/MoreMenuScreen.dart';
import 'package:hildegundis_app_new/screens/screens.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationBarController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                DateScreen(),
                FineScreen(),
                FormationScreenNew(),
                SongbookScreen(),
                MoreMenuScreen()
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            backgroundColor: ProjectConfig.ColorBottomNavigationBar,
            currentIndex: controller.tabIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: ProjectConfig.BNTextEvents,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.money_euro_circle),
                  label: ProjectConfig.BNFines,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.sportscourt),
                  label: ProjectConfig.BNFormation,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: ProjectConfig.BNSongbook,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: ProjectConfig.BNMoreMenu,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
            ],
          ),
        );
      },
    );
  }
}
