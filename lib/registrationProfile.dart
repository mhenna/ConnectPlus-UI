import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';


class RegistrationProfile extends StatefulWidget {
  RegistrationProfile({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _RegistrationProfileState createState() => _RegistrationProfileState();
}

class _RegistrationProfileState extends State<RegistrationProfile> {
  final LocalStorage localStorage = new LocalStorage('Connect+');
  final fnController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final carPlateController = TextEditingController();

  var asyncCall = false;
  var ip;
  var port;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void initState() {
    super.initState();
    setEnv();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fnController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextField(
      controller: fnController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Full Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final addressField = TextField(
      controller: addressController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Building, 67 Street, Nasr City",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final phoneField = TextField(
      controller: phoneController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "01XXXXXXXX",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final carPlateField = TextField(
      controller: carPlateController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "wkd890",
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
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFE15F5F),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          FocusScope.of(context).unfocus();
          setState(() {
            asyncCall = true;
          });
          Future.delayed(Duration(seconds: 1), () {
            register();
          });
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
                          Container(
                            width: 250,
                            child: fullNameField,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 250,
                            child: addressField,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 250,
                            child: phoneField,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 250,
                            child: carPlateField,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 250,
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: registerButton),
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

  void register() async {
    var user = localStorage.getItem('user');
    var url = 'http://' + ip + ':' + port + '/profile/addProfile';
    final msg = jsonEncode({
     "profile": { 'name': fnController.text, 'address': addressController.text, 'phoneNumber': phoneController.text, 'carPlate': carPlateController.text},
      "userId": user['_id']
    });
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: msg);
    if (response.statusCode == 200) {
      setState(() {
        asyncCall = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } else {
      setState(() {
        asyncCall = false;
      });
      _showDialog(response.body);
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
