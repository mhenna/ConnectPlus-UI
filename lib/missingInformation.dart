import 'package:flutter/material.dart';
import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/BusinessUnit.dart';

class MissingInformation extends StatefulWidget {
  MissingInformation({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _MissingInformationState createState() => _MissingInformationState();
}

class _MissingInformationState extends State<MissingInformation> {
  var asyncCall = false;
  String businessUnit = "";
  bool haveCar = true;
  void _asyncCallController(bool value) {
    print(value);
    setState(() {
      asyncCall = value;
    });
  }

  void businessUnitController(String value) {
    businessUnit = value;
  }

  void _displayCarPlate(bool _haveCar) {
    setState(() {
      haveCar = _haveCar;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    User user = widget.user;
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
            inAsyncCall: asyncCall,
            opacity: 0.5,
            progressIndicator: ImageRotate(),
            child: Center(
                child: Column(children: [
              Text("Welcome back, " + user.username),
              Container(
                width: width * 0.85,
                child: BusinessUnit(
                  passValue: businessUnitController,
                  asyncCallController: _asyncCallController,
                ),
              ),
            ]))));
  }
}
