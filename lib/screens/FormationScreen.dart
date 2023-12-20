import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/models/FormationPositionNew.dart';
import 'package:hildegundis_app_new/widgets/AppBar.dart';

class FormationScreenNew extends StatefulWidget {
  const FormationScreenNew({Key? key}) : super(key: key);

  @override
  _FormationScreenNewState createState() => _FormationScreenNewState();
}

class _FormationScreenNewState extends State<FormationScreenNew> {
  Map<int?, FormationPositionNew> allPositionsMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HildegundisAppBar(
          title: Text("Aufstellung"),
        ),
        body: StreamBuilder(
          stream: Database().getAllPositionsFromDatabase(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return (GridView.builder(
              itemCount: 18,
              // the total number of items in the grid
              itemBuilder: (context, index) {
                if (index == 0 || index == 2) {
                  return createFreePosition(snapshot, index);
                } else {
                  return createPosition(snapshot, index);
                }
                // a function that returns a widget for each item
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // the number of items on the cross axis
                crossAxisSpacing: 10,
                // the spacing between items on the cross axis
                mainAxisSpacing: 10,
                // the spacing between items on the main axis
                childAspectRatio: 1.4, // the width / height ratio of each item
              ),
            ));
          },
        ));
  }

  GestureDetector createPosition(AsyncSnapshot<dynamic> snapshot, int index) {
    getDocuments();
    if (allPositionsMap.containsKey(index)) {
      return GestureDetector(
          onTap: () {
            showBottomSheetForExisting(context, Colors.cyan, "Test", index,
                allPositionsMap[index]!.documentID!);
          },
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Center(
                    child: Column(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(allPositionsMap[index]!.imageUrl!),
                      ),
                    ),
                    Text(allPositionsMap[index]!.name!),
                  ],
                )),
              )));
    } else {
      return GestureDetector(
          onTap: () {
            showBottomSheet(context, Colors.cyan, "Test", index);
          },
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                      child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                  )))));
    }
  }

  Container createFreePosition(AsyncSnapshot<dynamic> snapshot, int index) {
    return Container(child: const Text(''));
  }

  // A function that shows a bottom sheet with a given color and text
  void showBottomSheet(
      BuildContext context, Color color, String text, int forPositionIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return (Container(
            height: 150,
            child: Column(
              children: [
                StreamBuilder(
                  stream: Database().getAllPositionsFromDatabase(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    return Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            int assignedPosition =
                                snapshot.data.docs[index]['position'];
                            return GestureDetector(
                                onTap: () {
                                  Database().updatePositionNew(
                                      snapshot.data.docs[index].id,
                                      forPositionIndex);

                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        child: Icon(Icons.abc_outlined),
                                        backgroundColor: assignedPosition == -1
                                            ? null
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(snapshot.data.docs[index]['name']),
                                    ],
                                  ),
                                ));
                          }),
                    );
                  },
                )
              ],
            )));
      },
    );
  }

  void showBottomSheetForExisting(BuildContext context, Color color,
      String text, int forPositionIndex, String docId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return (Container(
            height: 200,
            child: Column(
              children: [
                Spacer(flex: 1),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Database().removeFromFormation(docId);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            primary: Colors.lightGreen,
                            fixedSize: const Size(30, 30)),
                        child: const Icon(Icons.transit_enterexit))),
                Spacer(flex: 2),
                StreamBuilder(
                  stream: Database().getAllPositionsFromDatabase(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    return Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            int assignedPosition =
                                snapshot.data.docs[index]['position'];
                            return GestureDetector(
                                onTap: () {
                                  if (allPositionsMap.keys
                                      .contains(forPositionIndex)) {
                                    showAlertDialog(context);
                                  } else {
                                    Database().updatePositionNew(
                                        snapshot.data.docs[index].id,
                                        forPositionIndex);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        child: Icon(Icons.abc_outlined),
                                        backgroundColor: assignedPosition == -1
                                            ? null
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(snapshot.data.docs[index]['name']),
                                    ],
                                  ),
                                ));
                          }),
                    );
                  },
                )
              ],
            )));
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Position ist schon besetzt"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getDocuments();
    super.initState();
  }

  Future<QuerySnapshot> getDocuments() async {
    Map<int?, FormationPositionNew> allPositionsMapNew = {};
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('formation_new')
        .orderBy('position')
        .get();
    List<DocumentSnapshot> listOfDocuments = snapshot.docs;

    for (DocumentSnapshot current in listOfDocuments) {
      FormationPositionNew currentPosition = FormationPositionNew.empty();
      currentPosition.name = current["name"];
      currentPosition.position = current["position"];
      currentPosition.documentID = current.id;
      currentPosition.imageUrl = current["imageUrl"];

      allPositionsMapNew.putIfAbsent(
          currentPosition.position, () => currentPosition);
    }
    setState(() {
      allPositionsMap = allPositionsMapNew;
    });

    return snapshot;
  }
}
