import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/models/user_profile_request_params.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/login.dart';

class RegistrationProfile extends StatefulWidget {
  RegistrationProfile({Key key, this.title}) : super(key: key);
  final String title; // This widget is the root of your application.
  @override
  _RegistrationProfileState createState() => _RegistrationProfileState();
}

class _RegistrationProfileState extends State<RegistrationProfile> {
  final LocalStorage localStorage = new LocalStorage('Connect+');
  final fnController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final carPlateLettersController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final carPlateNumController = TextEditingController();
  var asyncCall = false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addressController.dispose();
    fnController.dispose();
    phoneController.dispose();
    carPlateLettersController.dispose();
    carPlateNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final fullNameField = TextFormField(
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
    final addressField = TextFormField(
      controller: addressController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.025, width * 0.02, height * 0.02),
          hintText: "Building, 67 Street, Nasr City",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your address';
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
    final carPlateLettersField = TextFormField(
      controller: carPlateLettersController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.03, height * 0.015, width * 0.02, height * 0.015),
          hintText: "رم",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final carPlateNumField = TextFormField(
      controller: carPlateNumController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.03, height * 0.015, width * 0.02, height * 0.015),
          hintText: "879",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final registerTitle = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Register ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 55,
                fontFamily: "Arial"))
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36.0, 220.0, 36.0, 50.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: registerTitle),
                          SizedBox(height: 20.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: width * 0.75,
                                  child: fullNameField,
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  width: width * 0.75,
                                  child: addressField,
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  width: width * 0.75,
                                  child: phoneField,
                                ),
                                SizedBox(height: 20.0),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: width * 0.30,
                                        child: carPlateNumField,
                                      ),
                                      Container(
                                        width: width * 0.30,
                                        child: carPlateLettersField,
                                      ),
                                      Tooltip(
                                        child: _getInfoIcon(),
                                        message:
                                            "It will be used for moveyourcar feature",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  width: width * 0.75,
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
                ),
              ),
            ),
          ),
        ));
  }

  Widget _getInfoIcon() {
    return new GestureDetector(
      child: new Icon(
        Icons.info,
        color: Utils.header,
        size: 20.0,
      ),
    );
  }

  void register() async {
    try {
      final params = UserProfileRequestParams.fromJson({
        'name': fnController.text,
        'address': addressController.text,
        'phoneNumber': phoneController.text,
        'carPlate':
            (carPlateNumController.text + carPlateLettersController.text),
      });

      final registeredProfile = await WebAPI.setProfile(params);
      localStorage.setItem("profile", registeredProfile);
      setState(() {
        asyncCall = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } catch (e) {
      localStorage.setItem("profile", null);
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
