import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:flutter/gestures.dart';
import 'package:connect_plus/login.dart';

class registration extends StatefulWidget {
  registration({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _registrationState createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final fnController = TextEditingController();
  final emController = TextEditingController();
  final pwController = TextEditingController();
  final algorithm = PBKDF2();
  TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);
  void initState() {
    super.initState();
  }

  String hashPassword() {
    final hash = Password.hash(pwController.text, algorithm);
    return hash;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fnController.dispose();
    emController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextField(
      controller: fnController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Full Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
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
    final registerTitle = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Register ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfff7501e),
                fontSize: 30.0,
                fontFamily: "Arial"))
      ]),
    );
    final registerButton = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          begin: Alignment(-1.0, 1.0),
          end: Alignment(1.0, -1.0),
          colors: [const Color(0xfff7501e), const Color(0xffed136e)],
          stops: [0.0, 1.0],
        ),
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showLoadingDialog();
          register();
          hideLoadingDialog();
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.normal)),
      ),
    );

//    final login = Text.rich(
//      TextSpan(children: <TextSpan>[
//        TextSpan(
//            text: ' Already a user? ',
//            style: TextStyle(
//                color: Colors.black,
//                fontSize: 15.0,
//                fontFamily: "Arial")),
//        TextSpan(
//            text: ' Login ',
//            style: TextStyle(
//                fontWeight: FontWeight.bold,
//                color: Color(0xfff7501e),
//                fontSize: 15.0,
//                fontFamily: "Arial"),
//            recognizer: TapGestureRecognizer()
//              ..onTap = () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => login()),
//                );
//              }
//        )
//      ]),
//    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      image: DecorationImage(
                        image: AssetImage("assets/logo2.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(25.0, 220.0, 25.0, 50.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: registerTitle),
                              SizedBox(height: 20.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: firstNameField,
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: emailField,
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: passwordField,
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: registerButton),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void register() async {
    var url = 'http://10.0.2.2:5400/user/register';
    final msg = jsonEncode({
      'name': fnController.text,
      'email': emController.text,
      'password': hashPassword(),
    });
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: msg);
    print(msg);
    if (response.statusCode == 200)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
