import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/AppBar.dart';

class FineScreen extends StatefulWidget {
  @override
  _FineScreenState createState() => _FineScreenState();
}

class _FineScreenState extends State<FineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(title: Text(ProjectConfig.TextAppBarFineOverview), appBar: AppBar(), widgets: [Icon(Icons.more_vert)],),
      body: new Text("FineScreen"),
    );
  }
}
