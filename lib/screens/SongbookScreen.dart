import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../constants.dart';
import '../widgets/AppBar.dart';

class SongbookScreen extends StatefulWidget{
  const SongbookScreen({Key? key}) : super(key: key);

  @override
  _SongbookScreenState createState() => _SongbookScreenState();
}

class _SongbookScreenState extends State<SongbookScreen>{
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final bool _isLoading = true;
  String pdfPath = "";

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(title: const Text(ProjectConfig.TextAppBarSongbookOverview), appBar: AppBar(), widgets: const [Icon(Icons.more_vert)],),
      body: SfPdfViewer.asset(
          'assets/files/Liederbuch.pdf'));
  }

}