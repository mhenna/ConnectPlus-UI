import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/models/wire_magazine.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/WireMagazineCard.dart';

class WireMagazines extends StatefulWidget {
  const WireMagazines({Key key}) : super(key: key);

  @override
  _WireMagazinesState createState() => _WireMagazinesState();
}

class _WireMagazinesState extends State<WireMagazines> {
  @override
  Widget build(BuildContext context) {
    Widget getContent(List<WireMagazine> wireMagazines) {
      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("The Wire"),
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
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: wireMagazines.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WireMagazineCard(
                            wireMagazine: wireMagazines[index],
                          );
                        })),
                Icon(
                  Icons.arrow_right_outlined,
                  size: 35,
                )
              ],
            ),
          ));
    }

    Widget getErrorContent(String error) {
      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("The Wire"),
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
          body: Center(child: Text(error)));
    }

    return FutureBuilder<List<WireMagazine>>(
      future: WebAPI.getWireMagazines(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<WireMagazine>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: Colors.white, child: ImageRotate());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return getErrorContent(
                "There was an error processing your request. Please try again later");
          } else if (snapshot.hasData) {
            List<WireMagazine> wireMagazines = snapshot.data;
            return getContent(wireMagazines);
          } else {
            return getErrorContent("No Recent Wire Magazines.");
          }
        } else {
          return getErrorContent('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
