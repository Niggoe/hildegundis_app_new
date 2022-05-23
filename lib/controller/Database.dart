import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/content/v2_1.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _votingRef;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .set({"name": user.name, "email": user.email, "avatar": user.avatar});
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
      snapshot.docs.forEach((doc) {
        allNames.add(doc['name']);
      });
    });
    return allNames;
  }

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
}
