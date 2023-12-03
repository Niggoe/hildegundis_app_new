import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreen createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var arguments = Get.arguments;
  late File _imagePicked;
  File avatar = File("assets/icons/avatar.png");
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UploadTask? _uploadTask;
  double progressPercent = 0.0;
  var imgURL;
  var futureImgURL;
  @override
  void initState() {
    super.initState();
    arguments = arguments ?? Get.arguments;
  }

  void startUpload() async {
    String filePath = "users_pics/${DateTime.now()}";
    var reference = _storage.ref().child(filePath);

    setState(() {
      _uploadTask = reference.putFile(_imagePicked);
      _uploadTask!.then((snapshot) {
        setState(() {
          snapshot.ref.getDownloadURL().then((imgURL) => imgURL = imgURL);
          futureImgURL = Future.value(snapshot.ref.getDownloadURL());
          Get.back(canPop: true);
        });
      });
    });
  }

  Future<void> pickImage(ImageSource source) async {
    PickedFile? selectedImage = await ImagePicker().getImage(
        source: source, maxHeight: 300.0, maxWidth: 300.0, imageQuality: 100);
    setState(() {
      if (selectedImage != null) {
        _imagePicked = File(selectedImage.path);
        //Navigator.pop(context);
        Get.dialog(
            AlertDialog(
              // contentPadding: const EdgeInsets.only(top: 200.0, bottom: 200.0),
              title: const Text("Candidate Image Upload"),
              content: SizedBox(
                height: 320.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(
                        _imagePicked,
                        filterQuality: FilterQuality.high,
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(height: 20.0),
                      _uploadTask != null
                          ? StreamBuilder(
                              stream: _uploadTask!.snapshotEvents,
                              builder: (context, snapshot) {
                                _uploadTask!.snapshotEvents
                                    .listen((TaskSnapshot snapshot) {
                                  setState(() {
                                    progressPercent =
                                        snapshot.bytesTransferred.toDouble() /
                                            snapshot.totalBytes.toDouble();
                                  });
                                });

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 45.0, right: 45.0),
                                      child: LinearProgressIndicator(
                                          semanticsLabel:
                                              "${(progressPercent * 100).toString()} % uploaded...",
                                          minHeight: 10.0,
                                          value: progressPercent * 100),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "${(progressPercent * 100).toString()} % uploaded...",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                );
                              })
                          : ElevatedButton.icon(
                              onPressed: () {
                                startUpload();
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text("Upload Image")),
                    ],
                  ),
                ),
              ),
            ),
            arguments: Get.arguments);
      } else {
        Get.snackbar("ERROR", "No Image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
        backgroundColor: ProjectConfig.ColorBackground,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                // child: Center(
                //   child: Image(
                //     height: 80.0,
                //     image: AssetImage('assets/images/logoapp.png'),
                //   ),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text('AUTHENTICATION | SIGN UP',
                    style: GoogleFonts.yanoneKaffeesatz(
                        fontSize: 30.0,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  Get.bottomSheet(
                      Container(
                        color: Colors.white,
                        height: 70.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  ImageSource source = ImageSource.gallery;
                                  pickImage(source);
                                },
                                icon: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.red,
                                ),
                                label: const Text("Pick from Gallery")),
                            ElevatedButton.icon(
                                onPressed: () {
                                  ImageSource source = ImageSource.camera;
                                  pickImage(source);
                                },
                                icon: const Icon(
                                  Icons.camera_enhance,
                                  color: Colors.green,
                                ),
                                label: const Text("Take picture with Camera"))
                          ],
                        ),
                      ),
                      settings: RouteSettings(arguments: Get.arguments));
                  setState(() {
                    _imagePicked = File('');
                  });
                },
                child: FutureBuilder(
                    future: Future.value(futureImgURL),
                    builder: (context, state) {
                      if (state.hasData) {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(state.data.toString()),
                          radius: 80.0,
                        );
                      }
                      return const CircleAvatar(
                        radius: 80.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.account_circle,
                                  size: 84.0,
                                ),
                              ),
                              Center(
                                child: Text("Add Image"),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                      prefixIcon: Icons.account_circle,
                      type: TextInputType.text,
                      obscure: false,
                    ),
                    InputField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email,
                      type: TextInputType.emailAddress,
                      obscure: false,
                    ),
                    InputField(
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock,
                      type: TextInputType.text,
                      obscure: true,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            imgURL = imgURL ??
                                "https://firebasestorage.googleapis.com/v0/b/electchain-8ea68.appspot.com/o/users_pics%2F2021-02-01%2000%3A13%3A24.350509?alt=media&token=5fb3c9e5-29da-4357-9f55-5de21cfa76b9";
                            Get.find<AuthController>().createUser(
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                                imgURL);

                            //Get.snackbar('SUCEESS', 'user created');
                          },
                          label: const Text('SIGN UP'),
                          icon: const Icon(Icons.verified_user),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const LoginScreen()),
                      child: const Text(
                        'Already have account ? Sign In there',
                        style: TextStyle(color: Colors.red, fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
