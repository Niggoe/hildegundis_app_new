import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/AppBar.dart';

class FormationScreen extends StatefulWidget{
  @override
  _FormationScreenState createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(title: Text(ProjectConfig.TextAppBarFormationOverview), appBar: AppBar(), widgets: [Icon(Icons.more_vert)],),
      body: new Text("FormationScreen"),
    );
  }

}