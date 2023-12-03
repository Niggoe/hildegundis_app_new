import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? avatar;
  bool? isAdmin;

  UserModel({this.id, this.name, this.email, this.avatar, this.isAdmin});

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel user = UserModel();
    user.id = doc.id;
    user.email = doc['email'];
    user.name = doc['name'];
    user.avatar = doc['avatar'];
    user.isAdmin = doc['isAdmin'];
    return user;
  }
}
