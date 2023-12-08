import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/models/models.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) => _userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel user = UserModel();
    user.id = doc.id;
    user.email = doc['email'];
    user.name = doc['name'];
    user.avatar = doc['avatar'];
    user.isAdmin = doc['isAdmin'];
    user.group = doc['group'];
    return user;
  }
}
