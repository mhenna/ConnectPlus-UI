import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:connect_plus/registration.dart';
import 'package:connect_plus/homepage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/foundation.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/ResetPassword.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalStorage localStorage = new LocalStorage('Connect+');

  final emController = TextEditingController();
  final pwController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);
  bool loading = false;
  bool asyncCall = false;
  SharedPreferences prefs;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    if (loading)
      return Scaffold(
        body: ImageRotate(),
      );
    else {
      final emailField = TextField(
        controller: emController,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                width * 0.05, height * 0.025, width * 0.02, height * 0.02),
            hintText: "Email ( @dell / @dellteams )",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      );
      final passwordField = TextField(
        controller: pwController,
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                width * 0.05, height * 0.025, width * 0.02, height * 0.02),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      );
      final loginTitle = Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
              text: ' Login ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 55,
                fontFamily: "Roboto",
              ))
        ]),
      );
      final register = Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
              text: ' Not a user? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: size * 30,
                fontFamily: "Roboto",
              )),
          TextSpan(
              text: ' Register now ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 30,
                fontFamily: "Roboto",
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registration()),
                  );
                })
        ]),
      );
      final loginButton = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: LinearGradient(
            colors: [
              Utils.secondaryColor,
              Utils.primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(
              width * 0.02, height * 0.023, width * 0.02, height * 0.023),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            setState(() {
              asyncCall = true;
            });
            final AuthState state = await sl<AuthService>().login(
              email: emController.text,
              password: pwController.text,
            );
            if (state == AuthState.Loggedin) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            } else {
              setState(() {
                asyncCall = false;
              });
              _showError(state);
            }
          },
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
      return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
            inAsyncCall: asyncCall,
            opacity: 0.5,
            progressIndicator: ImageRotate(),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/logo2.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.05,
                              height * 0.32, width * 0.05, height * 0.05),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: height * 0.03),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: loginTitle)),
                                SizedBox(height: height * 0.03),
                                Container(
                                  width: width * 0.85,
                                  child: emailField,
                                ),
                                SizedBox(height: height * 0.03),
                                Container(
                                  width: width * 0.85,
                                  child: passwordField,
                                ),
                                SizedBox(height: height * 0.027),
                                Container(
                                  width: width * 0.85,
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: loginButton),
                                ),
                              ],
                            ),
                          ),
                        ),
                        register,
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          height: 10,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text.rich(TextSpan(
                              text: ' Forgot Password? ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Utils.header,
                                fontSize: size * 30,
                                fontFamily: "Roboto",
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPassword()),
                                  );
                                })),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );
    }
  }

  void _showError(AuthState state) {
    String errorMessage = "Invalid Credentials!";
    if (state == AuthState.Unverified)
      errorMessage = "Email is unverified!";
    else if (state == AuthState.UserNotFound) errorMessage = "User not found!";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Oops!"),
          content: new Text(errorMessage),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Utils.header,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
