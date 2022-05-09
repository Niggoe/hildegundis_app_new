import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../constants.dart';
import '../widgets/AppBar.dart';

class SongbookScreen extends StatefulWidget{
  @override
  _SongbookScreenState createState() => _SongbookScreenState();
}

class _SongbookScreenState extends State<SongbookScreen>{
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;
  String pdfPath = "";

  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(title: Text(ProjectConfig.TextAppBarSongbookOverview), appBar: AppBar(), widgets: [Icon(Icons.more_vert)],),
      body: SfPdfViewer.asset(
          'assets/files/Liederbuch.pdf'));
  }

}