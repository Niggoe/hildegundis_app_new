import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm/flutter_fcm.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'controller/AuthController.dart';

class ProjectConfig {
  // Authorization Login
  AuthController authController = AuthController.instance;
  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GoogleSignIn googleSign = GoogleSignIn();

  // Date Overview
  static const FontColorDateOverview = Colors.black;
  static const IconColorDateOverview = Colors.redAccent;
  static const IconColorDateOverviewLeading = Colors.black;
  static const BoxDecorationColorDateOverview = Colors.white;

  static const TextFloatingActionButtonTooltipDateOverview =
      "Termin hinzufügen";
  static const TextNotLoggedInSnackbarMessage = "Bitte erst einloggen";
  static const TextNotAllowedDateEntry =
      "Leider darfst du keine Termine hinzufügen";
  static const TextNotAllowedTransactionEntry =
      "Leider darfst du keine Strafen hinzufügen";
  static const TextNotAllowedDateRemoval =
      "Leider darfst du keine Termine löschen";
  static const SnackbarBackgroundColorDateOverview = Colors.redAccent;
  static const TextDateOverviewTryToDeleteEvent = "Termin löschen?";
  static const TextDeleteEventDialogOptionYes = "OK";
  static const TextDeleteEventDialogOptionNo = "Abbruch";

  // AppBar
  static const TextAppBarFineOverview = "Strafen";
  static const TextAppBarDateOverview = "Termine";
  static const TextAppBarFormationOverview = "Aufstellung";
  static const TextAppBarSongbookOverview = "Gesangsbuch";
  static const TextAppBarDateDetail = "Termindetails";
  static const TextAppBarTitle = "Hildegundis von Meer";
  static const TextAppBarAboutMe = "About Me";
  static const TextAppBarImpressum = "Impressum";
  static const ColorAppBar = Colors.indigo;

  // Date Detail
  static const FontColorDateDetail = Colors.black;
  static var dateDetailFormat = DateFormat("dd.MM.yyyy HH:mm");
  static const FontSizeSubHeaderDateDetail = 16.0;
  static const FontSizeHeaderDateDetail = 20.0;

  // Global
  static const ColorBackground = Colors.white;
  static const serverKey =
      "AAAAb-jR3mU:APA91bF42NiOt1VJcSw_D3HFte-2lvQlmxxQnAbbc3ZFCnV6hzcZoks-uFtaaMzdnqGZiJko3w7ejo1pjEB490zuRgFknxk2EA856jhx2LL_Dp8e58yEZHlpFGqvPBJ7xhhtt2c59knV";

  //BottomNavigationBar
  static const ColorBottomNavigationBar = Colors.red;
  static const BNTextEvents = "Daten";
  static const BNFormation = "Aufstellung";
  static const BNSongbook = "Songbook";
  static const BNFines = "Strafen";
  static const BNMoreMenu = "Mehr";
  static const BNLogutMenu = "Logout";
  static const BNAboutMe = "About Me";
  static const BNImpressum = "Impressum";

  // AddEventScreen
  static const AddEventTitle = "Titel";
  static const AddEventClothes = "Kleidung";
  static const AddEventLocation = "Ort";
  static const AddEventDate = "Datum";
  static const AddEventTime = "Zeit";

  // TextInputFields
  static const ValidatorMessage = "Bitte das Feld ausfüllen";
  static const ValidatorSuccessfulMessage = "Valid";

  // Messages
  static const PasswordHint = "Passwort";
  static const EmailHint = "Email";
  static const LoginButtonText = "Login";
  static const ErrorLogin = "Error during login";
}
