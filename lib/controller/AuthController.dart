import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:hildegundis_app_new/screens/screens.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  late Rx<GoogleSignInAccount?> googleSignInAccount;

  @override
  void onReady() {
    super.onReady();
    // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
    // Since we have to use that many times I just made a constant file and declared there

    _firebaseUser = Rx<User?>(ProjectConfig().auth.currentUser);
    googleSignInAccount =
        Rx<GoogleSignInAccount?>(ProjectConfig().googleSign.currentUser);

    _firebaseUser.bindStream(ProjectConfig().auth.userChanges());
    ever(_firebaseUser, _setInitialScreen);

    googleSignInAccount
        .bindStream(ProjectConfig().googleSign.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => const AuthScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => Homescreen());
    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    print(googleSignInAccount);
    if (googleSignInAccount == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => const AuthScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => Homescreen());
    }
  }

  /* @override
  // ignore: must_call_super
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    setUserToUserController();
    ever(_firebaseUser, _setInitialScreen);
  }*/

  /*void setUserToUserController() async {
    usercontroller.user = await Database().getUser(_auth.currentUser!.uid);
  }*/

  /*_setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const AuthScreen());
    } else {
      if (usercontroller.user!.group == 'hildegundis')
        Get.offAll(() => const Homescreen());
      else if (usercontroller.user!.group == 'not-authorized')
        Get.offAll(() => const UnregisteredHomescreen());
      else
        Get.offAll(() => const UnregisteredHomescreen());
    }
  }*/

  void createUser(name, email, password, imgURL) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //Create a user in firestore
      UserModel user = UserModel(
          id: authResult.user!.uid, name: name, email: email, avatar: imgURL);
      if (await Database().createNewUserNew(user)) {
        Get.find<UserController>().user = user;
        Get.back();
      }
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      var authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserController userController = Get.find<UserController>();
      userController.user = await Database().getUser(authResult.user!.uid);
      Get.back();
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  void register(String email, password) async {
    try {
      await ProjectConfig()
          .auth
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  void login(String email, password) async {
    try {
      await ProjectConfig()
          .auth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount =
          await ProjectConfig().googleSign.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await ProjectConfig()
            .auth
            .signInWithCredential(credential)
            .catchError((onErr) => print(onErr));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e.toString());
    }
  }

  void signOut() {
    try {
      _auth.signOut();
      Get.find<UserController>().clear();
      Get.find<BottomNavigationBarController>().clear();
      print("User logged out");
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  Future<bool> isUserInAllowedGroup(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data()! as Map<String, dynamic>?;
      if (userData!['group'] == 'hildegundis') {
        return true;
      }
    }
    return false;
  }
}
