import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormationScreen extends StatefulWidget {
  const FormationScreen({Key? key}) : super(key: key);

  @override
  _FormationScreenState createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  String name = "";
  int formation = 0;
  bool loggedIn = false;
  Map<int?, FormationPosition> allPositionsMap = Map();

  void moveBall(FormationPosition newPosition) {
    Map<int?, FormationPosition> allUsers = Map();
    for (FormationPosition pos in allPositionsMap.values) {
      if (pos.name != newPosition.name) {
        allUsers.putIfAbsent(pos.position, () => pos);
      } else {
        newPosition.documentID = pos.documentID;
        updatePosition(pos, newPosition);
        allUsers.putIfAbsent(newPosition.position, () => newPosition);
      }
    }
    setState(() {
      allPositionsMap = allUsers;
    });
  }

  void removeFromFormation(FormationPosition newPosition) {
    Map<int?, FormationPosition> allUsers = Map();
    for (FormationPosition pos in allPositionsMap.values) {
      if (pos.name != newPosition.name) {
        allUsers.putIfAbsent(pos.position, () => pos);
      } else {
        newPosition.documentID = pos.documentID;
        updateRemove(pos, newPosition);
        int? lowestValue = allPositionsMap.keys
            .reduce((value, element) => value! < element! ? value : element);
        if (lowestValue == 0) {
          lowestValue = -1;
        }
        newPosition.position = lowestValue;
        allUsers.putIfAbsent(lowestValue! - 1, () => newPosition);
      }
    }
    setState(() {
      allPositionsMap = allUsers;
    });
  }

  Future updateRemove(FormationPosition old, FormationPosition newPos) async {
    Database().removePosition(old, newPos);
  }

  Future updatePosition(FormationPosition old, FormationPosition newPos) async {
    Database().updatePosition(old, newPos);
  }

  Future<QuerySnapshot> getDocuments(formation) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('formation')
        .where("formation", isEqualTo: formation)
        .orderBy('position')
        .get();
    List<DocumentSnapshot> listOfDocuments = snapshot.docs;
    int unassignedPositon = 0;
    for (DocumentSnapshot current in listOfDocuments) {
      FormationPosition currentPosition = FormationPosition.empty();
      currentPosition.formation = current["formation"];
      currentPosition.name = current["name"];
      currentPosition.position = current["position"];
      currentPosition.documentID = current.id;
      if (currentPosition.position! < 0) {
        currentPosition.position =
            currentPosition.position! - unassignedPositon;
        unassignedPositon += 1;
      }
      allPositionsMap.putIfAbsent(
          currentPosition.position, () => currentPosition);
    }
    setState(() {
      allPositionsMap = allPositionsMap;
    });
    return snapshot;
  }

  List<Widget> getAllUnassignedUsers() {
    List<Widget> notAssignedUser = [];
    for (FormationPosition currentPosition in allPositionsMap.values) {
      if (currentPosition.position! < 0) {
        notAssignedUser.add(MovableBall(
            currentPosition.position,
            true,
            moveBall,
            currentPosition.name,
            currentPosition.documentID,
            loggedIn));
      }
    }
    return notAssignedUser;
  }

  List<Widget> getFormationPositions() {
    checkIfAllowed();
    List<Widget> allPositions = [];
    allPositions.add(Row(
      children: <Widget>[
        Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getAllUnassignedUsers()),
        ),
        MovableBall(99, false, removeFromFormation, "", "", loggedIn)
      ],
    ));

    allPositions.add(
      const Divider(
        color: Colors.black,
      ),
    );

    allPositions.add(createFrontRow());

    for (int i = 0; i < 15; i++) {
      if (i % 3 == 0) {
        allPositions.add(Expanded(
          child: createRow(i),
        ));
      }
    }
    return allPositions;
  }

  Row createRow(int position) {
    List<Widget> allRowEntries = [];
    int positionCurrent = position;
    for (int i = 0; i < 3; i++) {
      positionCurrent += 1;
      allRowEntries.add(createSlot(positionCurrent));
    }
    return Row(
      children: allRowEntries,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  Row createFrontRow() {
    List<Widget> allRowEntries = [];
    allRowEntries.add(createSlot(0));
    return Row(
      children: allRowEntries,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  MovableBall createSlot(int position) {
    if (allPositionsMap.containsKey(position)) {
      return MovableBall(
          position,
          true,
          moveBall,
          allPositionsMap[position]!.name,
          allPositionsMap[position]!.documentID,
          loggedIn);
    } else {
      return MovableBall(position, false, moveBall, "", "", loggedIn);
    }
  }

  void checkIfAllowed() {
    UserController userController = Get.find<UserController>();
    UserModel activeUser = userController.user;
    if (activeUser.isAdmin!) {
      setState(() {
        loggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDocuments(3);
    // checkIfAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: getFormationPositions(),
      ),
    );
  }
}
