import 'package:hildegundis_app_new/models/models.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/screens/screens.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User?> _firebaseUser = Rxn<User?>();
  var usercontroller = Get.put(UserController());
  String? get user => _firebaseUser.value!.email;

  @override
  // ignore: must_call_super
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  void createUser(name, email, password) async {
    try {
      var _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //Create a user in firestore
      UserModel _user =
      UserModel(id: _authResult.user!.uid, name: name, email: email);
      if (await Database().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        Get.back();
      }
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      Get.find<UserController>().user =
      await Database().getUser(_authResult.user!.uid);
      Get.back();
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  void signOut() {
    try {
      _auth.signOut();
      Get.find<UserController>().clear();
      print("User logged out");
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }
}
