import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/services/web_api.dart';

class BusinessUnit extends StatefulWidget {
  BusinessUnit({Key key, this.PassValue, this.asyncCallController, this.userBU})
      : super(key: key);
  final void Function(String value) PassValue;
  final void Function(bool value) asyncCallController;
  final String userBU;

  @override
  _BusinessUnit createState() => _BusinessUnit();
}

class _BusinessUnit extends State<BusinessUnit> {
  String dropdownValue = '';
  bool Loaded = false;
  List<String> BUs = new List<String>();

  void _getBusinessUnits() async {
    BUs = new List<String>();
    BUs = await WebAPI.getBusinessUnits();
    widget.asyncCallController(false);
    if (dropdownValue == '') dropdownValue = BUs[0];
    widget.PassValue(dropdownValue);
    setState(() {
      Loaded = true;
    });
  }

  void initState() {
    if (widget.userBU != null) {
      dropdownValue = widget.userBU;
      BUs.add(dropdownValue);
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {widget.asyncCallController(true)});
    _getBusinessUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Loaded
        ? DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(
              color: Utils.header,
            ),
            underline: Container(
              height: 2,
              color: Utils.header,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
                widget.PassValue(dropdownValue);
              });
            },
            items: BUs.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        : Container();
  }
}
