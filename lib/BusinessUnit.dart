import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/services/web_api.dart';

class BusinessUnit extends StatefulWidget {
  BusinessUnit({Key key, this.PassValue}) : super(key: key);
  final void Function(String value) PassValue;
  @override
  _BusinessUnit createState() => _BusinessUnit();
}

class _BusinessUnit extends State<BusinessUnit> {
  String dropdownValue = 'one';
  bool Loaded = false;
  List<String> BUs = new List<String>();
  void _getBusinessUnits() async {
    BUs = await WebAPI.getBusinessUnits();
    setState(() {
      Loaded = true;
    });
    print(BUs);
  }

  void initState() {
    _getBusinessUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Loaded
        ? DropdownButton<String>(
            value: BUs[0],
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
