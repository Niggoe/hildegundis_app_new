import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/models/models.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _votingRef;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "avatar": user.avatar,
        "isAdmin": user.isAdmin,
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> createNewUserNew(UserModel user) async {
    try {
      await _firestore.collection('users_new').doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "avatar": user.avatar,
        "isAdmin": user.isAdmin,
        "group": "not-authorized"
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return Get.find<UserController>().fromDocumentSnapshot(doc);
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Stream<QuerySnapshot> getEventsFromDatabase() {
    return _firestore.collection('events').snapshots();
  }

  Stream<QuerySnapshot> getEventsFromDatabaseAfterToday() {
    return _firestore
        .collection('events')
        .where('startdate', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy("startdate", descending: false)
        .snapshots();
  }

  Future<DocumentReference> addEvent(EventModel addedEvent) async {
    return await _firestore.collection("events").add({
      'title': addedEvent.title,
      'clothes': addedEvent.clothes,
      'location': addedEvent.location,
      'startdate': addedEvent.starttime,
      'enddate': addedEvent.endtime
    });
  }

  Future<List<String>> getAllNamesFromFirebase() async {
    List<String> allNames = [];
    await _firestore.collection('users').get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        allNames.add(doc['name']);
      }
    });
    return allNames;
  }

  /**
   * Formation Handling
   */

  Future<void> updatePosition(FormationPosition old, FormationPosition newPos) {
    return _firestore
        .collection('formation')
        .doc(old.documentID)
        .update({'position': newPos.position});
  }

  Future<void> removePosition(FormationPosition old, FormationPosition newPos) {
    return _firestore
        .collection('formation')
        .doc(old.documentID)
        .update({'position': -1});
  }

  Future<QuerySnapshot> getAllPositions(int formation) {
    return _firestore
        .collection('formation')
        .where("formation", isEqualTo: formation)
        .orderBy('position')
        .get();
  }

  /**
   * Fine Handling
   */

  Stream<QuerySnapshot> getAllFines() {
    return _firestore.collection('fines').orderBy('date').snapshots();
  }

  Future<void> addNewFine(Fine newFine) {
    return _firestore.collection("fines").add({
      'name': newFine.name,
      'reason': newFine.reason,
      'amount': newFine.amount,
      'date': newFine.date,
      'payed': newFine.payed
    });
  }

  Future<void> togglePayed(DocumentSnapshot snapshot) {
    return _firestore
        .collection("fines")
        .doc(snapshot.id)
        .update({'payed': !snapshot['payed']});
  }

  Stream<QuerySnapshot> getAllFinesForName(String name) {
    return _firestore
        .collection("fines")
        .where("name", isEqualTo: name)
        .orderBy("date")
        .snapshots();
  }

  /**
   * New Formation Handling
   */

  // create method to fetch all positions from firebase
  Stream<QuerySnapshot> getAllEmptyPositionsFromFirebase() {
    return _firestore
        .collection('formation_new')
        .where("position", isEqualTo: -1)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllPositionsFromDatabase() {
    return _firestore
        .collection('formation_new')
        .orderBy('position', descending: false)
        .snapshots();
  }

  Future<void> updatePositionNew(String documentID, int position) {
    return _firestore
        .collection('formation_new')
        .doc(documentID)
        .update({'position': position});
  }

  Future<void> removeFromFormation(String documentID) {
    return _firestore
        .collection('formation_new')
        .doc(documentID)
        .update({'position': -1});
  }
}
