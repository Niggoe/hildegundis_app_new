import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/Database.dart';
import 'package:hildegundis_app_new/models/models.dart';
import "package:intl/intl.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:hildegundis_app_new/constants.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';

class FineDetailUI extends StatefulWidget {
  static String tag = "firebase-detail-view-Strafes";

  const FineDetailUI({Key? key}) : super(key: key);

  @override
  FineDetailUIState createState() => FineDetailUIState();
}

class FineDetailUIState extends State<FineDetailUI> {
  String name = Get.arguments;
  Widget _makeCard(BuildContext context, DocumentSnapshot document) {
    Fine currentStrafe = Fine();

    currentStrafe.date =
        document["date"] == '' ? null : document["date"].toDate();
    currentStrafe.name = document['name'];
    currentStrafe.reason = document["reason"];
    currentStrafe.payed = document["payed"];
    if (document["amount"].runtimeType == int) {
      currentStrafe.amount = document["amount"].toDouble();
    } else {
      currentStrafe.amount = document["amount"];
    }
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.red,
      child: Container(
        decoration: const BoxDecoration(
            color: ProjectConfig.BoxDecorationColorDateOverview,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: _buildListItem(context, currentStrafe),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Fine currentStrafe) {
    var formatter = DateFormat("dd.MM.yyyy");
    var date = currentStrafe.date;
    var datestring = formatter.format(date!);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      key: ValueKey(currentStrafe.date),
      leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(
                    width: 1.0, color: ProjectConfig.FontColorDateOverview))),
        child: const Icon(Icons.calendar_today,
            color: ProjectConfig.IconColorDateOverviewLeading),
      ),
      title: Text(
        currentStrafe.name!,
        style: const TextStyle(
            color: ProjectConfig.FontColorDateOverview,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Column(children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(Icons.linear_scale,
                color: ProjectConfig.IconColorDateOverview),
            Text(datestring,
                style: const TextStyle(
                    color: ProjectConfig.FontColorDateOverview)),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            ),
            Text(
              "${currentStrafe.amount}€",
              style:
                  const TextStyle(color: ProjectConfig.FontColorDateOverview),
            )
          ],
        ),
        Text(currentStrafe.reason!,
            style: const TextStyle(color: ProjectConfig.IconColorDateOverview))
      ]),
      trailing: Icon(
          currentStrafe.payed! ? Icons.attach_money : Icons.money_off,
          color: (currentStrafe.payed! ? Colors.green[500] : Colors.red[500])),
      //onLongPress: () => handleLongPress(document),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HildegundisAppBar(
        title: Text("${ProjectConfig.TextAppBarFineOverview} - $name"),
        appBar: AppBar(),
        widgets: const [],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder(
      stream: Database().getAllFinesForName(name),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, index) {
              return _makeCard(context, snapshot.data.docs[index]);
              //if (index < data.length) return buildRow(data[index], index);
            });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
