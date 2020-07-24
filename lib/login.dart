import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:connect_plus/registration.dart';
import 'package:password/password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  login({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final emController = TextEditingController();
  final pwController = TextEditingController();
  final algorithm = PBKDF2();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void initState() {
    super.initState();
  }

  String hashPassword(){
    final hash = Password.hash(pwController.text, algorithm);
    return hash;
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: emController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
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
                color: Colors.black,
                fontSize: 15.0,
                fontFamily: "Arial")),
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
              }
        )
      ]),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFE15F5F),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          loginPressed();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
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
                    padding: const EdgeInsets.fromLTRB(36.0, 220.0, 36.0, 30.0),
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
      ),
    );
  }
  void loginPressed() async {
    var url = 'http://10.0.2.2:5400/user/login';
    final msg = jsonEncode({
      'email': emController.text,
      'password': hashPassword(),
    });
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: msg);
    print(msg);
//    if(response.statusCode == 200)
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => myVerificationPage(email: emController.text)),
//      );
//
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
