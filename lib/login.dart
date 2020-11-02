import 'package:connect_plus/models/login_request_params.dart';
import 'package:connect_plus/models/user_profile.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:connect_plus/registration.dart';
import 'package:connect_plus/homepage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:password/password.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'widgets/pushNotification.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/foundation.dart';

class login extends StatefulWidget {
  login({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final LocalStorage localStorage = new LocalStorage('Connect+');
  final PushNotificationService pushNotification = PushNotificationService();

  final emController = TextEditingController();
  final pwController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);
  bool loading = true;
  bool asyncCall = false;
  SharedPreferences prefs;

  void initState() {
    super.initState();
    pushNotification.initialize();
    checkLoggedInStatus();
  }

  void checkLoggedInStatus() async {
    try {
      prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token != null) {
        final user = await WebAPI.checkToken(token);
        UserProfile profile;
        if (user.profile == null) {
          profile = await WebAPI.getProfile(user.profileId);
        } else {
          profile = user.profile;
        }
        localStorage.setItem("profile", profile);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void loginPressed() async {
    try {
      final loginParams = LoginRequestParams.fromJson({
        'identifier': emController.text,
        // TODO: encode password in app and decode password on server
        'password': pwController.text
      });

      final userWithToken = await WebAPI.login(loginParams);
      UserProfile profile;
      if (userWithToken.user.profile == null) {
        profile = await WebAPI.getProfile(userWithToken.user.profileId);
      } else {
        profile = userWithToken.user.profile;
      }

      prefs.setString("token", userWithToken.jwt);
      localStorage.setItem("profile", profile);

      setState(() {
        asyncCall = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      prefs.setString("token", null);
      localStorage.setItem("profile", null);
      setState(() {
        asyncCall = false;
      });
      _showDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    if (loading)
      return LoadingWidget();
    else {
      final emailField = TextField(
        controller: emController,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                width * 0.05, height * 0.02, width * 0.02, height * 0.02),
            hintText: " Email (@dell.com)",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      );
      final passwordField = TextField(
        controller: pwController,
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                width * 0.05, height * 0.02, width * 0.02, height * 0.02),
            hintText: " Password",
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
                fontFamily: "Arial",
              ))
        ]),
      );
      final register = Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
              text: ' Not a user? ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size * 25,
                  fontFamily: "Arial")),
          TextSpan(
              text: ' Register now ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Utils.header,
                  fontSize: size * 25,
                  fontFamily: "Arial"),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => registration()),
                  );
                })
        ]),
      );
      final loginButton = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
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
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() {
              asyncCall = true;
            });
            Future.delayed(Duration(seconds: 1), () {
              loginPressed();
            });
          },
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
      return Scaffold(
        body: ModalProgressHUD(
            inAsyncCall: asyncCall,
            opacity: 0.5,
            progressIndicator: LoadingText(),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Utils.background,
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
                                  width: width * 0.65,
                                  child: emailField,
                                ),
                                SizedBox(height: height * 0.03),
                                Container(
                                  width: width * 0.65,
                                  child: passwordField,
                                ),
                                SizedBox(height: height * 0.027),
                                Container(
                                  width: width * 0.6,
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: loginButton),
                                ),
                              ],
                            ),
                          ),
                        ),
                        register
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );
    }
  }

  void _showDialog(err) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Oops!"),
          content: new Text(err),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget LoadingWidget() {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          new Text("Loading"),
        ],
      ),
    ));
  }

  Widget LoadingText() {
    var size = MediaQuery.of(context).size.aspectRatio;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Text(
                "Loading...",
                style:
                    TextStyle(fontSize: size * 55, color: Colors.orangeAccent),
              ),
            ],
          ),
        ));
  }
}
