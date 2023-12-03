import 'package:flutter/material.dart';

import 'package:hildegundis_app_new/controller/controllers.dart';
import '../constants.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:hildegundis_app_new/models/models.dart';

import 'screens.dart';
import 'package:get/get.dart';

class FineScreen extends StatefulWidget {
  const FineScreen({Key? key}) : super(key: key);

  @override
  _FineScreenState createState() => _FineScreenState();
}

class _FineScreenState extends State<FineScreen> {
  List<Fine> allStrafes = [];

  Widget _makeCard(BuildContext context, DocumentSnapshot document) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(
            color: ProjectConfig.BoxDecorationColorDateOverview,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: _buildListItem(context, document),
      ),
    );
  }

  Future addEventPressed() async {
    bool allowed = checkIfAllowed();
    if (allowed) {
      Fine? addedFine =
          await Navigator.of(context).push(MaterialPageRoute<Fine>(
              builder: (BuildContext context) {
                return const AddFineDialogUI();
              },
              fullscreenDialog: true));

      if (addedFine != null) {
        Database().addNewFine(addedFine);
      }

      // sendFCMMessage(addedFine);
    } else {
      var snackBar = const SnackBar(
        content: Text(ProjectConfig.TextNotAllowedTransactionEntry),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Future<int> sendFCMMessage(Fine strafeAdded) async {
  //   final FCM fcm = new FCM(ProjectConfig.serverKey);
  //   final Message fcmMessage = new Message()
  //     ..to = "/topics/all"
  //     ..title = "Neue Strafe hinzugefügt"
  //     ..body = strafeAdded.name +
  //         " \t" +
  //         strafeAdded.amount.toString() +
  //         "€\n" +
  //         strafeAdded.reason;
  //   final String messageID = await fcm.send(fcmMessage);
  // }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    var formatter = DateFormat("dd.MM.yyyy");
    var date = document['date'].toDate();
    var datestring = formatter.format(date);
    bool payed = document['payed'];

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      key: ValueKey(document.id),
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
        document['name'],
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
              "${document["amount"]}€",
              style:
                  const TextStyle(color: ProjectConfig.FontColorDateOverview),
            )
          ],
        ),
        Text(document['reason'],
            style: const TextStyle(color: ProjectConfig.IconColorDateOverview))
      ]),
      trailing: IconButton(
        icon: (payed
            ? const Icon(Icons.attach_money)
            : const Icon(Icons.money_off)),
        color: (payed ? Colors.green[500] : Colors.red[500]),
        onPressed: () {
          _togglePayed(document);
        },
      ),
      onTap: () {
        var nameKey = document['name'];
        getDocuments(nameKey);
      },
      //onLongPress: () => handleLongPress(document),
    );
  }

  _togglePayed(DocumentSnapshot document) {
    if (checkIfAllowed()) {
      Database().togglePayed(document);
    } else {
      var snackBar = const SnackBar(
        content: Text(ProjectConfig.TextNotAllowedTransactionEntry),
        backgroundColor: ProjectConfig.SnackbarBackgroundColorDateOverview,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool checkIfAllowed() {
    UserController userController = Get.find<UserController>();
    UserModel activeUser = userController.user;
    if (activeUser.isAdmin!) {
      return true;
    }
    return false;
  }

  void getDocuments(nameKey) {
    Get.to(() => const FineDetailUI(), arguments: nameKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Fine>> perNameMap = {};
    return Scaffold(
      appBar: HildegundisAppBar(
        title: const Text(ProjectConfig.TextAppBarFineOverview),
        appBar: AppBar(),
        widgets: const [],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        backgroundColor: Colors.redAccent,
        onPressed: () {
          addEventPressed();
        },
        tooltip: ProjectConfig.TextFloatingActionButtonTooltipDateOverview,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: Database().getAllFines(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  _makeCard(context, snapshot.data.docs[index]),
            );
          }),
    );
  }
}
