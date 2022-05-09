import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';

import '../widgets/AppBar.dart';

class DateScreen extends StatefulWidget {
  @override
  _DateScreenState createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(title: Text(ProjectConfig.TextAppBarDateOverview), appBar: AppBar(), widgets: [Icon(Icons.more_vert)],),
      body: new Text("DateScreen"),
    );
  }
}
