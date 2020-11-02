import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/models/user_profile.dart';
import 'package:connect_plus/models/user_profile_request_params.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final LocalStorage localStorage = new LocalStorage("Connect+");
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController carPlateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserProfile profile = new UserProfile();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProfile();
    getProfile();
  }


  void setProfile() async {
    setState(() {
      profile = UserProfile.fromJson(localStorage.getItem('profile'));
    });
  }

  void getProfile() async {
      setState(() {
        nameController = TextEditingController(text: profile.name);
        addressController = TextEditingController(text: profile.address);
        carPlateController = TextEditingController(text: profile.carPlate);
        phoneController = TextEditingController(text: profile.phoneNumber);
      });
  }

  //Missing validation that edit profile is success or a failure .. but tested it is working
  void editProfile() async {
    Map<String, dynamic> editedProfile = {
      "name": nameController.text != "" ? nameController.text : profile.name,
      "address": addressController.text != ""
          ? addressController.text
          : profile.address,
      "phoneNumber": phoneController.text != ""
          ? phoneController.text
          : profile.phoneNumber,
      "carPlate": carPlateController.text != ""
          ? carPlateController.text
          : profile.carPlate
    };

    final updatedProfile = await WebAPI.updateProfile(UserProfileRequestParams.fromJson(editedProfile));

    localStorage.setItem('profile', updatedProfile);
  }

  Widget _getLabel(String value) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.only(
            left: width * 0.08, right: width * 0.08, top: height * 0.02),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  value,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _getField(String value, TextEditingController controller) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.only(
            left: width * 0.08, right: width * 0.08, top: height * 0.01),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: value,
                ),
                enabled: !_status,
                autofocus: !_status,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Utils.background,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Profile Details"),
          centerTitle: true,
          backgroundColor: Utils.header,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Utils.secondaryColor,
                  Utils.primaryColor,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        body: new Container(
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: height * 0.23,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.05),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: width * 0.22,
                                    height: height * 0.14,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/as.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Utils.background,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: height * 0.03),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(right: width * 0.08),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _getLabel("Name"),
                                _getField(
                                    profile.name.toString(), nameController),
                                _getLabel("Address"),
                                _getField(profile.address.toString(),
                                    addressController),
                                _getLabel("Phone Number"),
                                _getField(profile.phoneNumber.toString(),
                                    phoneController),
                                _getLabel(
                                    "Car Plate # (Please write letters in Arabic)"),
                                _getField(profile.carPlate.toString(),
                                    carPlateController)
                              ],
                            ),
                          ),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    editProfile();
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Utils.header,
        radius: 20.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
