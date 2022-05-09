import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/widgets/AppBar.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:hildegundis_app_new/controller/controllers.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConfig.ColorBackground,
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                // child: Center(
                //   child: Image(
                //     image: AssetImage('assets/images/logoapp.png'),
                //   ),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text('AUTHENTICATION | LOG IN IN',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 30.0,
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
                      Get.find<AuthController>().loginUser(
                          _emailController.text, _passwordController.text);
                    },
                    label: Text('SIGN IN'),
                    icon: Icon(Icons.verified_user),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              FlatButton(
                onPressed: () => Get.to(() => AuthScreen()),
                child: Text(
                  'Dont have an account ? Sign up there',
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              )
            ]),
      )),
    );
  }
}
