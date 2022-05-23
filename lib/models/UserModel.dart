import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? avatar;

  UserModel({this.id, this.name, this.email, this.avatar});

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel _user = UserModel();
    _user.id = doc.id;
    _user.email = doc['email'];
    _user.name = doc['name'];
    _user.avatar = doc['avatar'];
    return _user;
  }
}
