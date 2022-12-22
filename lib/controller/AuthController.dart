import 'package:hildegundis_app_new/models/models.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/screens/screens.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  var usercontroller = Get.put(UserController());
  String? get user => _firebaseUser.value!.email;

  @override
  // ignore: must_call_super
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    setUserToUserController();
    ever(_firebaseUser, _setInitialScreen);
  }

  void setUserToUserController() async {
    usercontroller.user = await Database().getUser(_auth.currentUser!.uid);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const AuthScreen());
    } else {
      Get.offAll(() => const Homescreen());
    }
  }

  void createUser(name, email, password, imgURL) async {
    try {
      if (!email.contains('@hildegundis.de')) {
        Get.snackbar(
            'Processing Error', 'You need to be within hildegundis scope');
      } else {
        var _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //Create a user in firestore
        UserModel _user = UserModel(
            id: _authResult.user!.uid,
            name: name,
            email: email,
            avatar: imgURL);
        if (await Database().createNewUser(_user)) {
          Get.find<UserController>().user = _user;
          Get.back();
        }
      }
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserController userController = Get.find<UserController>();
      userController.user = await Database().getUser(_authResult.user!.uid);
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
