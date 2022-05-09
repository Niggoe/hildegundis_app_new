import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/BottomNavigationBarController.dart';
import 'package:hildegundis_app_new/screens/screens.dart';

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationBarController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                DateScreen(),
                FineScreen(),
                FormationScreen(),
                SongbookScreen()
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            backgroundColor: ProjectConfig.ColorBottomNavigationBar,
            currentIndex: controller.tabIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: ProjectConfig.BNTextEvents,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.sportscourt),
                  label: ProjectConfig.BNFines,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bell),
                  label: ProjectConfig.BNFormation,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: ProjectConfig.BNSongbook,
                  backgroundColor: ProjectConfig.ColorBottomNavigationBar),
            ],
          ),
        );
      },
    );
  }
}
