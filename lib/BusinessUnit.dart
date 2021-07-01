import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/services/web_api.dart';

class BusinessUnit extends StatefulWidget {
  BusinessUnit({Key key, this.passValue, this.asyncCallController, this.userBU})
      : super(key: key);
  final void Function(String value) passValue;
  final void Function(bool value) asyncCallController;
  final String userBU;

  @override
  _BusinessUnit createState() => _BusinessUnit();
}

class _BusinessUnit extends State<BusinessUnit> {
  String dropdownValue = '';
  bool loaded = false;
  List<String> businessUnits = new List<String>();

  void _getBusinessUnits() async {
    businessUnits = new List<String>();
    businessUnits = await WebAPI.getBusinessUnits();
    widget.asyncCallController(false);
    if (dropdownValue == '') dropdownValue = businessUnits[0];
    widget.passValue(dropdownValue);
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    if (widget.userBU != null) {
      dropdownValue = widget.userBU;
      businessUnits.add(dropdownValue);
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {widget.asyncCallController(true)});
    _getBusinessUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return loaded
        ? Column(
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
                  child: DropdownButton<String>(
                    isExpanded: true,
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
                        widget.passValue(dropdownValue);
                      });
                    },
                    items: businessUnits
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
            ],
          )
        : Container();
  }
}
