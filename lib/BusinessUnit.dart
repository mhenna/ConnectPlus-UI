import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/services/web_api.dart';

class BusinessUnit extends StatefulWidget {
  BusinessUnit({Key key, this.PassValue, this.asyncCallController})
      : super(key: key);
  final void Function(String value) PassValue;
  final void Function(bool value) asyncCallController;

  @override
  _BusinessUnit createState() => _BusinessUnit();
}

class _BusinessUnit extends State<BusinessUnit> {
  String dropdownValue = 'one';
  bool Loaded = false;
  List<String> BUs = new List<String>();
  void _getBusinessUnits() async {
    BUs = await WebAPI.getBusinessUnits();
    widget.asyncCallController(false);
    dropdownValue = BUs[0];
    print(dropdownValue);
    setState(() {
      Loaded = true;
    });
    print(BUs);
  }

  void initState() {
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
