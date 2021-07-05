import 'package:flutter/material.dart';
import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/BusinessUnit.dart';
import 'package:connect_plus/widgets/car_plate_widget.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/homepage.dart';

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
  List<String> carPlates = new List<String>();
  void initState() {
    carPlates.add("");
    super.initState();
  }

  void _asyncCallController(bool value) {
    setState(() {
      asyncCall = value;
    });
  }

  void businessUnitController(String value) {
    setState(() {
      businessUnit = value;
    });
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
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.1,
                        width * 0.05, height * 0.03),
                    child: Card(
                        child: Column(children: [
                      Text.rich(TextSpan(
                        text: 'Welcome back ' + user.username.split(' ')[0],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utils.header,
                            fontSize: size * 40,
                            fontFamily: "Roboto"),
                      )),
                      Text("Please complete your information"),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.05,
                            height * 0.02, width * 0.05, height * 0.03),
                        child: SaveButton(
                          carPlates: carPlates,
                          businessUnit: businessUnit,
                          asyncCallController: _asyncCallController,
                          haveCar: haveCar,
                        ),
                      )
                    ]))))));
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

class SaveButton extends StatefulWidget {
  SaveButton(
      {Key key,
      this.carPlates,
      this.businessUnit,
      this.asyncCallController,
      this.haveCar})
      : super(key: key);
  final String businessUnit;
  final List<String> carPlates;
  final Function asyncCallController;
  final bool haveCar;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    return Container(
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
          widget.asyncCallController(true);
          List<String> nullCarPlates;
          if (widget.haveCar == false) {
            List<String> nullCarPlates = new List<String>();
            nullCarPlates.add(null);
          }
          await sl<AuthService>().updateProfile(
            carPlates: widget.haveCar ? widget.carPlates : nullCarPlates,
            businessUnit:
                widget.businessUnit == "" ? null : widget.businessUnit,
          );
          widget.asyncCallController(false);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
        child: Text(
          "Save & Continue",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
