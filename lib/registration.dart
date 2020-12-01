import 'package:connect_plus/login.dart';
import 'package:connect_plus/models/register_request_params.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:localstorage/localstorage.dart';

class registration extends StatefulWidget {
  registration({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _registrationState createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final LocalStorage localStorage = new LocalStorage('Connect+');
  final fnController = TextEditingController();
  final emController = TextEditingController();
  final pwController = TextEditingController();
  final phoneController = TextEditingController();

  final algorithm = PBKDF2();
  var asyncCall = false;
  var ip;
  var port;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fnController.dispose();
    emController.dispose();
    pwController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final firstNameField = TextFormField(
      controller: fnController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.025, width * 0.02, height * 0.02),
          hintText: "Full Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
    final emailField = TextFormField(
      controller: emController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.025, width * 0.02, height * 0.02),
          hintText: "Email ( @dell / @dellteams ).com",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your email';
        }
        bool emailValid =
            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@dell.com")
                .hasMatch(value.toString());
        bool emailValid2 =
            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@dellteams.com")
                .hasMatch(value.toString());
        if (!emailValid && !emailValid2) {
          return "Please enter a valid email";
        }
        return null;
      },
    );
    final passwordField = TextFormField(
      controller: pwController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.025, width * 0.02, height * 0.02),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
    final phoneField = TextFormField(
      controller: phoneController,
      obscureText: false,
      maxLength: 11,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.025, width * 0.02, height * 0.02),
          hintText: "01XXXXXXXXX",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your phone number';
        }
        bool emailValid =
            RegExp("^[0][1][0-9]{2,10}").hasMatch(value.toString());
        if (!emailValid || value.length < 11) {
          return "Please enter a valid phone number";
        }
        return null;
      },
    );
    final registerTitle = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Register ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 55,
                fontFamily: "Roboto"))
      ]),
    );
    final loginPath = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Already a user? ',
            style: TextStyle(
                color: Colors.black,
                fontSize: size * 30,
                fontFamily: "Roboto")),
        TextSpan(
            text: ' Login',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 30,
                fontFamily: "Roboto"),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              })
      ]),
    );
    final registerButton = Container(
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
        onPressed: () {
          if (_formKey.currentState.validate()) {
            FocusScope.of(context).unfocus();
            setState(() {
              asyncCall = true;
            });
            Future.delayed(Duration(seconds: 1), () {
              register();
            });
          }
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.normal)),
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
                            height * 0.32, width * 0.05, height * 0.03),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: height * 0.03),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.01),
                                      child: registerTitle)),
                              SizedBox(height: height * 0.03),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: width * 0.85,
                                      child: firstNameField,
                                    ),
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
                                    SizedBox(height: 20.0),
                                    Container(
                                      width: width * 0.85,
                                      child: phoneField,
                                    ),
                                    SizedBox(height: height * 0.027),
                                    Container(
                                      width: width * 0.85,
                                      child: Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: registerButton),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      loginPath,
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void register() async {
    try {
      final registerParams = RegisterRequestParameters.fromJson({
        'username': fnController.text.toString(),
        'email': emController.text.toString(),
        'password': pwController.text.toString(),
        'phoneNumber': phoneController.text.toString(),
      });
      final registeredUser = await WebAPI.register(registerParams);
      localStorage.setItem("user", registeredUser.user.toJson());
      setState(() {
        asyncCall = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } catch (e) {
      setState(() {
        asyncCall = false;
      });
      _showDialog(e.toString());
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
}
