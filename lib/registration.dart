import 'package:connect_plus/login.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/car_plate_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/BusinessUnit.dart';
import 'package:connect_plus/widgets/terms_and_conditions_popup.dart';
import 'package:connect_plus/models/registration_status.dart';

class Registration extends StatefulWidget {
  Registration({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final LocalStorage localStorage = new LocalStorage('Connect+');
  final fnController = TextEditingController();
  final emController = TextEditingController();
  final pwController = TextEditingController();
  final phoneController = TextEditingController();

  final algorithm = PBKDF2();
  var asyncCall = false;
  var ip;
  var port;
  bool haveCar = true;
  List<String> carPlates = new List<String>();
  bool reloaded = false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  String businessUnit = "";
  UserCredential userCredentials;
  bool _agreedToTermsConditions = false;
  bool _termsConditionsError = false;
  void initState() {
    carPlates.add("");
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

  void _displayCarPlate(bool _haveCar) {
    setState(() {
      haveCar = _haveCar;
    });
  }

  void businessUnitController(String value) {
    businessUnit = value;
  }

  void _asyncCallController(bool value) {
    print(value);
    setState(() {
      asyncCall = value;
    });
  }

  void _setAgreedToTermsConditions(bool newValue) {
    setState(() {
      _agreedToTermsConditions = newValue;
      if (newValue == true) {
        _termsConditionsError = false;
      }
    });
  }
  String _tokenizeRegistrationError(String error)
  {
    if (error.contains("] ")){
      return error.split("] ")[1];
    }
    else return error;
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
          hintText: "Email ( @dell / @dellteam ).com",
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
            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@dellteam.com")
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
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: ' Register ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Utils.header,
              fontSize: size * 55,
              fontFamily: "Roboto",
            ),
          )
        ],
      ),
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
                  MaterialPageRoute(builder: (context) => Login()),
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
        onPressed: () async {
          setState(() {
            _termsConditionsError = !_agreedToTermsConditions;
          });

          if (_formKey.currentState.validate() &&
              _agreedToTermsConditions == true) {
            FocusScope.of(context).unfocus();
            setState(() {
              asyncCall = true;
            });
            final pnToken = await sl<PushNotificationsService>().token;
            RegistrationStatus registered = await sl<AuthService>().register(
              email: emController.text,
              password: pwController.text,
              username: fnController.text,
              phoneNumber: phoneController.text,
              carPlates: haveCar ? carPlates : null,
              businessUnit: businessUnit,
              pushNotificationToken: pnToken,
            );
            if (registered.success) {
              await successDialog();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            } else {
              //TODO: change dialog logic
              String error=_tokenizeRegistrationError(registered.error);
              _showDialog(error);
            }
            setState(() {
              asyncCall = false;
            });
          }
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.white, fontWeight: FontWeight.normal),
        ),
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
                      padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.25,
                          width * 0.05, height * 0.03),
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
                                  Container(
                                    width: width * 0.85,
                                    child: BusinessUnit(
                                      passValue: businessUnitController,
                                      asyncCallController: _asyncCallController,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    width: width * 0.85,
                                    child: CarPlateRadioButton(
                                      displayCarPlate: _displayCarPlate,
                                    ),
                                  ),
                                  haveCar == true
                                      ? CarPlatesList(
                                          onChanged: (plates) {
                                            carPlates = plates;
                                          },
                                        )
                                      : Container(),
                                  SizedBox(height: height * 0.027),
                                  Row(children: <Widget>[
                                    Checkbox(
                                      value: _agreedToTermsConditions,
                                      onChanged: _setAgreedToTermsConditions,
                                    ),
                                    GestureDetector(
                                        onTap: () =>
                                            _setAgreedToTermsConditions(
                                                !_agreedToTermsConditions),
                                        child: Text.rich(TextSpan(
                                            text: 'I agree to the',
                                            style: TextStyle(
                                              fontSize: size * 24,
                                              color: Colors.black,
                                              fontFamily: "Roboto",
                                            )))),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return TermsAndConditionsPopup(
                                                    context);
                                              });
                                        },
                                        child: Text.rich(TextSpan(
                                            text: ' Terms and conditions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: size * 24,
                                              color: Utils.header,
                                              fontFamily: "Roboto",
                                            )))),
                                  ]),
                                  _termsConditionsError
                                      ? Text.rich(TextSpan(
                                          text:
                                              'Please check terms and conditions',
                                          style: TextStyle(
                                            fontSize: size * 20,
                                            color: Colors.red,
                                            fontFamily: "Roboto",
                                          )))
                                      : SizedBox(),
                                  SizedBox(height: height * 0.027),
                                  Container(
                                    width: width * 0.85,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: registerButton,
                                    ),
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
        ),
      ),
    );
  }

  Future<void> successDialog() {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text(
            "Welcome!",
            textAlign: TextAlign.center,
          ),
          content: new Text(
            'Account created successfully, verification Link has been sent to your email',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(err) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text(
              "Oops!",
              textAlign: TextAlign.center,
            ),
            content: new Text(
                err),
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
}

class CarPlateInputTitle extends StatelessWidget {
  CarPlateInputTitle({
    Key key,
  }) : super(key: key);

  final _toolTipKey = GlobalKey<State<Tooltip>>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Car Plate",
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            final dynamic tooltip = _toolTipKey.currentState;
            tooltip?.ensureTooltipVisible();
          },
          child: Tooltip(
            key: _toolTipKey,
            message: "Car plate data will be used for move your car feature",
            preferBelow: false,
            child: Icon(
              Icons.info_outline,
              size: 20,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}

class CarPlateRadioButton extends StatefulWidget {
  final void Function(bool value) displayCarPlate;
  CarPlateRadioButton({
    Key key,
    this.displayCarPlate,
  }) : super(key: key);
  @override
  _State createState() => _State();
}

class QuestionsOptions {
  String name;
  int index;
  QuestionsOptions({this.name, this.index});
}

class _State extends State<CarPlateRadioButton> {
  String radioItem = 'Yes';
  int id = 1;
  List<QuestionsOptions> optionsList = [
    QuestionsOptions(
      index: 1,
      name: "Yes",
    ),
    QuestionsOptions(
      index: 0,
      name: "No",
    ),
  ];

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Have a car ?",
            style: TextStyle(fontSize: 20.0),
          ),
          Column(
            children: <Widget>[
              Row(
                children: optionsList
                    .map((data) => Expanded(
                            child: RadioListTile(
                          title: Text("${data.name}"),
                          groupValue: id,
                          value: data.index,
                          onChanged: (val) {
                            widget.displayCarPlate(data.index == 1);
                            setState(() {
                              radioItem = data.name;
                              id = data.index;
                            });
                          },
                        )))
                    .toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CarPlatesList extends StatefulWidget {
  final List<String> initialPlates;
  final Function(List<String> plate) onChanged;
  const CarPlatesList({
    Key key,
    this.initialPlates,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _CarPlatesListState createState() => _CarPlatesListState();
}

class _CarPlatesListState extends State<CarPlatesList> {
  List<String> carPlates = [""];

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
        CarPlateInputTitle(),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shrinkWrap: true,
          children: carPlates.map((plate) {
            int index = carPlates.indexOf(plate);
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Expanded(
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
                  Visibility(
                    visible: carPlates.length > 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: InkWell(
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onTap: () {
                          setState(() {
                            carPlates.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Visibility(
          visible: carPlates.length < 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
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
                )),
          ),
        ),
      ],
    );
  }
}
