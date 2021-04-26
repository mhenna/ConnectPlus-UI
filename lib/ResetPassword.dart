import 'package:flutter/material.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/Header.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool asyncCall = false;
  final emController = TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    Future<void> successDialog() {
      // flutter defined function
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text(
              "Success!",
              textAlign: TextAlign.center,
            ),
            content: new Text(
              'Reset link has been sent to your email.',
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Close",
                  style: TextStyle(
                      color: Utils.header,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showError() {
      String errorMessage =
          "No user found with that email, Please check your email again or try to register.";

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

    final resetTitle = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Reset your password ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Utils.header,
              fontSize: size * 40,
              fontFamily: "Roboto",
            ))
      ]),
    );
    Widget emailField = TextFormField(
      controller: emController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.025, width * 0.02, height * 0.02),
          hintText: "Email ( @dell / @dellteams )",
          hintStyle: TextStyle(fontSize: 16),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    Widget resetButton = Container(
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
          setState(() {
            asyncCall = true;
          });
          String status = await _resetPassword(emController.text);
          setState(() {
            asyncCall = false;
          });
          if (status == null)
            successDialog();
          else
            _showError();
        },
        child: Text("Reset Passsword",
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
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Header(),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.05, height * 0.05, width * 0.05, height * 0.05),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.02,
                          width * 0.05, height * 0.05),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.01),
                                    child: resetTitle)),
                            SizedBox(height: height * 0.03),
                            Container(width: width * 0.85, child: emailField),
                            SizedBox(height: height * 0.03),
                            Container(width: width * 0.85, child: resetButton),
                          ]),
                    ),
                  ),
                ),
              ],
            ))));
  }
}

Future<String> _resetPassword(String email) async {
  String status = await sl<AuthService>().resetPassword(email);
  return status;
}
