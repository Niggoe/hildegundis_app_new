import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/app.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(
          appBar: AppBar(), title: Text(ProjectConfig.TextAppBarImpressum)),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Card(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Autor:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Nikolas Gross\nAm Fronhof 28\n40667 Meerbusch',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Card(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Vielen Dank fürs Benutzen der App. Feedback gerne an feedback@nigromarmedia.de',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )),
        ),
      ]),
    );
  }
}
