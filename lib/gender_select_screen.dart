import 'package:connect_plus/services/firestore_services.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class GenderSelectScreen extends StatefulWidget {
  const GenderSelectScreen({Key key}) : super(key: key);

  @override
  State<GenderSelectScreen> createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  List<String> genderOptions=["Male","Female"];
  String genderSelectedVal='Male';
  FirestoreServices _fs=FirestoreServices();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('Gender Select'),
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
        body:Column(
            children:[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 45),
              child: Text(
                "Please select your gender to continue using the app:",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          Row(
            children: genderOptions
                .map((data) => Expanded(
                  child: RadioListTile(
              title: Text("$data"),
              groupValue: genderSelectedVal,
              value: data,
              onChanged: (val) {
                  setState(() {
                    genderSelectedVal = data;
                  });
              },
            ),
                ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:50.0),
            child: AppButton(title: "Confirm", onPress: (){
              _fs.addGender(genderSelectedVal);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
            }),
          )

          ],
        )
          ),
    );
  }
}
