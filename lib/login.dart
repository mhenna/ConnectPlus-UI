import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:connect_plus/registration.dart';
import 'package:connect_plus/homepage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:password/password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  final emController = TextEditingController();
  final pwController = TextEditingController();
  final algorithm = PBKDF2();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  SharedPreferences prefs;
  var ip;
  var port;
  var loading = true;
  var asyncCall = false;

  void initState() {
    super.initState();
    setEnv();
    checkLoggedInStatus();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  String hashPassword() {
    final hash = Password.hash(pwController.text, algorithm);
    return hash;
  }

  void checkLoggedInStatus() async {
    prefs = await SharedPreferences.getInstance();
    var url = 'http://' + ip + ':' + port + '/user/validate';
    var token = prefs.getString("token");

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    }).timeout(Duration(seconds: 5), onTimeout: () {
      setState(() {
        loading = false;
      });
     _showDialog("Internet connection problem");
      return null;
    });

    try {
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        localStorage.setItem("token", token);
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

    }
  }

  void loginPressed() async {
    //use these values in .env for android simulator, actual ip for iOS and physical devices
    var url = 'http://' + ip + ':' + port + '/user/login';
    final msg = jsonEncode({
      'email': emController.text,
      'password': hashPassword(),
    });

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: msg);

    if (response.statusCode == 200) {
      localStorage.setItem("token", json.decode(response.body)["token"]);
      localStorage.setItem("profile", json.decode(response.body)["profile"]);

      prefs.setString("token", json.decode(response.body)["token"]);
      setState(() {
        asyncCall = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      setState(() {
        asyncCall = false;
      });
      _showDialog(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return LoadingWidget();
    else {
      final emailField = TextField(
        controller: emController,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email(@dell.com)",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      );
      final passwordField = TextField(
        controller: pwController,
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                  color: Color(0xfff7501e),
                  fontSize: 30.0,
                  fontFamily: "Arial"))
        ]),
      );
      final register = Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
              text: ' Not a user? ',
              style: TextStyle(
                  color: Colors.black, fontSize: 15.0, fontFamily: "Arial")),
          TextSpan(
              text: ' Register now ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xfff7501e),
                  fontSize: 15.0,
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
      final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFFE15F5F),
        child: MaterialButton(
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                      color: Color(0xfffafafa),
                      image: DecorationImage(
                        image: AssetImage("assets/logo2.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(36.0, 220.0, 36.0, 30.0),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: loginTitle),
                                SizedBox(height: 20.0),
                                Container(
                                  width: 250,
                                  child: emailField,
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  width: 250,
                                  child: passwordField,
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  width: 250,
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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Text(
                "Loading...",
                style: TextStyle(fontSize: 30, color: Colors.orangeAccent),
              ),
            ],
          ),
        ));
  }
}
