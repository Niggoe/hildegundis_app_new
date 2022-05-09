import 'package:hildegundis_app_new/models/models.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;
  set user(UserModel value) => this._userModel.value = value;
  void clear() {
    _userModel.value = UserModel();
  }

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel _user = UserModel();
    _user.id = doc.id;
    _user.email = doc['email'];
    _user.name = doc['name'];
    return _user;
  }
}
