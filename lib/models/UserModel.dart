import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? avatar;
  bool? isAdmin;

  UserModel({this.id, this.name, this.email, this.avatar, this.isAdmin});

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel _user = UserModel();
    _user.id = doc.id;
    _user.email = doc['email'];
    _user.name = doc['name'];
    _user.avatar = doc['avatar'];
    _user.isAdmin = doc['isAdmin'];
    return _user;
  }
}
