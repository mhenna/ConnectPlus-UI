import 'package:connect_plus/login.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
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
  final carPlateController = TextEditingController();
  final algorithm = PBKDF2();
  var asyncCall = false;
  var ip;
  var port;
  bool haveCar = true;
  bool reloaded = false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  String businessUnit = "";
  UserCredential userCredentials;
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
    carPlateController.dispose();
    super.dispose();
  }

  void _displayCarPlate(bool _haveCar) {
    setState(() {
      if (_haveCar == false) carPlateController.clear();
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
          if (_formKey.currentState.validate()) {
            FocusScope.of(context).unfocus();
            setState(() {
              asyncCall = true;
            });
            final pnToken = await sl<PushNotificationsService>().token;
            bool registered = await sl<AuthService>().register(
              email: emController.text,
              password: pwController.text,
              username: fnController.text,
              phoneNumber: phoneController.text,
              carPlate: carPlateController.text,
              businessUnit: businessUnit,
              pushNotificationToken: pnToken,
            );
            if (registered) {
              await successDialog();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            } else {
              //TODO: change dialog logic
              _showDialog('Could not register');
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
                        padding: EdgeInsets.fromLTRB(width * 0.05,
                            height * 0.25, width * 0.05, height * 0.03),
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
                                      child: BusinessUnitWidget(
                                        businessUnitController:
                                            businessUnitController,
                                        asyncCallController:
                                            _asyncCallController,
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    Container(
                                      width: width * 0.85,
                                      child: carRadioButton(
                                        displayCarPlate: _displayCarPlate,
                                      ),
                                    ),
                                    haveCar == true
                                        ? Container(
                                            width: width * 0.85,
                                            child: CarPlateForm(
                                              carPlateController:
                                                  carPlateController,
                                            ),
                                          )
                                        : Container(),
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
        if (err == '400') {
          return CupertinoAlertDialog(
            title: new Text(
              "Oops!",
              textAlign: TextAlign.center,
            ),
            content: new Text('Full Name/Email Address is Already Taken!'),
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: new Text(
              "Oops!",
              textAlign: TextAlign.center,
            ),
            content: new Text(
                'Connection timed out! Please check your internet connection and try again.'),
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}

class CarPlateForm extends StatefulWidget {
  const CarPlateForm({
    Key key,
    @required this.carPlateController,
  }) : super(key: key);

  final TextEditingController carPlateController;

  @override
  _CarPlateFormState createState() => _CarPlateFormState();
}

class _CarPlateFormState extends State<CarPlateForm> {
  String _plateLetters = "";
  String _plateNumbers = "";

  String _validateLetters(String letters) {
    if (_plateLetters.isEmpty) {
      return "Empty field";
    }
    bool lettersValid = RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]+\$")
        .hasMatch(letters.toString());
    if (!lettersValid) {
      return "Arabic letters only";
    }
    return null;
  }

  String _validateNumbers(String numbers) {
    if (_plateNumbers.isEmpty) {
      return "Empty field";
    }
    bool numbersAreValid =
        RegExp("^[\u0621-\u064A\u0660-\u0669]+\$").hasMatch(numbers.toString());
    if (!numbersAreValid) {
      return "Arabic numerals only";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarPlateInputTitle(),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: CarPlateTextField(
                validator: _validateNumbers,
                hintText: "١٢٣",
                onChanged: (numbers) {
                  _plateNumbers = numbers;
                  widget.carPlateController.text =
                      _plateLetters + _plateNumbers;
                },
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: CarPlateTextField(
                validator: _validateLetters,
                hintText: "أ ب ج",
                onChanged: (letters) {
                  _plateLetters = letters;
                  widget.carPlateController.text =
                      _plateLetters + _plateNumbers;
                },
              ),
            ),
          ],
        ),
      ],
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

class CarPlateTextField extends StatelessWidget {
  final void Function(String value) onChanged;
  final String Function(String value) validator;
  final String hintText;

  const CarPlateTextField({
    Key key,
    this.onChanged,
    this.validator,
    this.hintText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(
          width * 0.05,
          height * 0.025,
          width * 0.02,
          height * 0.02,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
      ),
    );
  }
}

class carRadioButton extends StatefulWidget {
  final void Function(bool value) displayCarPlate;
  carRadioButton({
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

class _State extends State<carRadioButton> {
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
            Column(children: <Widget>[
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
            ])
          ]),
    );
  }
}

class BusinessUnitWidget extends StatelessWidget {
  final void Function(String value) businessUnitController;
  final void Function(bool value) asyncCallController;
  const BusinessUnitWidget({
    Key key,
    @required this.businessUnitController,
    @required this.asyncCallController,
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
    return Column(
      children: [
        SizedBox(height: 20.0),
        Container(
          width: width * 0.85,
          child: Text(
            'Business Unit',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Container(
          width: width * 0.85,
          child: BusinessUnit(
            passValue: onChange,
            asyncCallController: onLoaded,
          ),
        ),
      ],
    );
  }
}
