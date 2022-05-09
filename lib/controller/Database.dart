import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _votingRef;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        "name": user.name,
        "email": user.email,
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
}
