import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/BottomNavigationBarController.dart';
import 'package:hildegundis_app_new/screens/MoreMenuScreen.dart';
import 'package:hildegundis_app_new/screens/screens.dart';

class UnregisteredHomescreen extends StatelessWidget {
  const UnregisteredHomescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationBarController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [SongbookScreen(), MoreMenuScreen()],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            backgroundColor: ProjectConfig.ColorBottomNavigationBar,
            currentIndex: controller.tabIndex,
            items: const [
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
