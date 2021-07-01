import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/car_plate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/BusinessUnit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final LocalStorage localStorage = new LocalStorage("Connect+");
  bool _notEditing = true;
  bool _loading = false;
  String _BusinessUnit = "";
  final FocusNode myFocusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> _carPlates;

  void _asyncCallController(bool value) {
    print(value);
    setState(() {
      _loading = value;
    });
  }

  void businessUnitController(String value) {
    setState(() {
      _BusinessUnit = value;
    });
  }

  //Missing validation that edit profile is success or a failure .. but tested it is working
  void editProfile() async {
    try {
      if (_formKey.currentState.validate()) {
        await sl<AuthService>().updateProfile(
          username: nameController.text == "" ? null : nameController.text,
          phoneNumber: phoneController.text == "" ? null : phoneController.text,
          carPlates: _carPlates,
          businessUnit: _BusinessUnit == "" ? null : _BusinessUnit,
        );
        setState(() {
          _notEditing = true;
        });
      }
    } catch (e) {
      CupertinoAlertDialog(
        content: new Text("An Error Occured, Please try again!"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
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
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          content: new Text("Profile Edited Successfully!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  Widget _getField(
      String value, TextEditingController controller, bool isEmail) {
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
                enabled: isEmail ? false : !_notEditing,
                autofocus: !_notEditing,
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
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        opacity: 0.5,
        progressIndicator: ImageRotate(),
        child: new Container(
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
                                    width: width * 0.20,
                                    height: height * 0.14,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                          'assets/as.png',
                                        ),
                                        fit: BoxFit.contain,
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
                                    _notEditing
                                        ? _getEditIcon()
                                        : new Container(),
                                  ],
                                )
                              ],
                            ),
                          ),
                          FutureBuilder<User>(
                            future: sl<AuthService>().user,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final user = snapshot.data;

                              return Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _getLabel("Full Name"),
                                      _getField(user.username.toString(),
                                          nameController, false),
                                      _getLabel("Email"),
                                      _getField(user.email.toString(),
                                          emailController, true),
                                      _getLabel("Phone Number"),
                                      _getField(user.phoneNumber.toString(),
                                          phoneController, false),
                                      _getLabel("Car Plate"),
                                      user.carPlates.isEmpty && _notEditing
                                          ? NoCarsText()
                                          : _notEditing
                                              ? CarPlatesList(
                                                  carPlates: user.carPlates,
                                                )
                                              : EditingCarPlatesList(
                                                  initialPlates: user.carPlates,
                                                  onChanged: (plates) {
                                                    _carPlates = plates;
                                                  },
                                                ),
                                      _getLabel("Business Unit"),
                                      _notEditing
                                          ? _getField(
                                              user.businessUnit, null, false)
                                          : BusinessUnitWidget(
                                              userBu: user.businessUnit,
                                              asyncCallController:
                                                  _asyncCallController,
                                              businessUnitController:
                                                  businessUnitController,
                                            ),
                                      !_notEditing
                                          ? _getActionButtons(user)
                                          : new Container(),
                                    ],
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons(User user) {
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
                  editProfile();
                  setState(() {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
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
                    _notEditing = true;
                    nameController.text = user.username;
                    emailController.text = user.email;
                    phoneController.text = user.phoneNumber;
                    _carPlates = user.carPlates;
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
          _notEditing = false;
        });
      },
    );
  }
}

class BusinessUnitWidget extends StatelessWidget {
  final void Function(String value) businessUnitController;
  final void Function(bool value) asyncCallController;
  final String userBu;
  const BusinessUnitWidget({
    Key key,
    @required this.businessUnitController,
    @required this.asyncCallController,
    this.userBu,
  }) : super(key: key);

  void onChange(String val) {
    businessUnitController(val);
  }

  void onLoaded(bool val) {
    asyncCallController(val);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.only(
            left: width * 0.08, right: width * 0.08, top: height * 0.01),
        child: Column(
          children: [
            Container(
              width: width * 0.85,
              child: BusinessUnit(
                passValue: onChange,
                asyncCallController: onLoaded,
                userBU: userBu,
              ),
            ),
          ],
        ));
  }
}

class NoCarsText extends StatelessWidget {
  const NoCarsText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        left: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Text(
        "No cars registered",
        style: TextStyle(color: Theme.of(context).disabledColor),
      ),
    );
  }
}

class CarPlatesList extends StatelessWidget {
  final List<String> carPlates;
  const CarPlatesList({
    Key key,
    @required this.carPlates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shrinkWrap: true,
      children: carPlates.map((plate) {
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: CarPlatePicker(
            editable: false,
            initialPlate: plate,
            onChanged: (_) {},
          ),
        );
      }).toList(),
    );
  }
}

class EditingCarPlatesList extends StatefulWidget {
  final List<String> initialPlates;
  final Function(List<String> plate) onChanged;
  const EditingCarPlatesList({
    Key key,
    this.initialPlates,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _EditingCarPlatesListState createState() => _EditingCarPlatesListState();
}

class _EditingCarPlatesListState extends State<EditingCarPlatesList> {
  List<String> carPlates;
  @override
  void initState() {
    carPlates = [];
    carPlates.addAll(widget.initialPlates); // deep copy
    super.initState();
  }

  void changePlate(index, plate) {
    if (index > carPlates.length - 1) {
      carPlates.add(plate);
    } else {
      carPlates[index] = plate;
    }
    widget.onChanged(carPlates);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 12, left: 24),
          shrinkWrap: true,
          children: carPlates.map((plate) {
            int index = carPlates.indexOf(plate);
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: CarPlatePicker(
                        key: ObjectKey(
                          plate, // prevents incorrect plate being deleted
                        ),
                        editable: true,
                        initialPlate: plate,
                        onChanged: (plate) {
                          changePlate(index, plate);
                        },
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        carPlates.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Visibility(
          visible: carPlates.length < 2,
          child: InkWell(
            onTap: () {
              setState(() {
                carPlates.add('');
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text.rich(TextSpan(
                  text: "+ Add another car plate",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: "Roboto",
                  ))),
            ),
          ),
        ),
      ],
    );
  }
}
