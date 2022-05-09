import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';

class HildegundisAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = ProjectConfig.ColorAppBar;
  final Text? title;
  final AppBar? appBar;
  final List<Widget>? widgets;

  /// you can add more fields that meet your needs

  const HildegundisAppBar({Key? key, this.title, this.appBar, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize =>  new Size.fromHeight(kToolbarHeight);
}