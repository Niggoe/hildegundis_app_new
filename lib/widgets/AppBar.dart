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
      title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: ProjectConfig.TextAppBarTitle,
                style: TextStyle(fontSize: 20),
              ),
              TextSpan(text: "\n"),
              TextSpan(
                  text: title!.data.toString(),
                  style: const TextStyle(fontSize: 16))
            ],
          )),
      backgroundColor: backgroundColor,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
