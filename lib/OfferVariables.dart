import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:connect_plus/Offer.dart';

class OfferVariables extends StatefulWidget {
  @override
  _OfferVariables createState() => _OfferVariables();
}

class _OfferVariables extends State<OfferVariables> {
  var ip, port;
  var offer_list = [];
  Uint8List mostRecentOffer;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  void initState() {
    super.initState();
    setEnv();
    getEvents();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getEvents() async {
    String token = localStorage.getItem("token");
    var url = 'http://$ip:$port/offers/recent';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      setState(() {
        offer_list = json.decode(response.body);
        this.mostRecentOffer =
            base64Decode(offer_list.elementAt(0)['logo']['fileData']);
      });
    }
  }

  Widget mostRecent() {
    if (mostRecentOffer == null) return CircularProgressIndicator();
    return Container(
        height: 200,
        decoration: BoxDecoration(
          image: new DecorationImage(
              image: MemoryImage(mostRecentOffer), fit: BoxFit.cover),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        mostRecent(),
        Expanded(
            child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: constructEvents(),
        )),
      ],
    );
  }

  List<Widget> constructEvents() {
    List<Widget> list = List<Widget>();
    for (var offer in offer_list) {
      list.add(Single_Offer(
        offer_name: offer['name'],
        offer_picture: base64Decode(offer['logo']['fileData']),
        offer_date: offer['createdAt'].toString().split("T")[0],
        offer: offer,
      ));
    }
    return list;
  }
}

class Single_Offer extends StatelessWidget {
  final offer_name;
  final offer_picture;
  final offer_date;
  final offer;

  //constructor
  Single_Offer(
      {this.offer_name, this.offer_picture, this.offer_date, this.offer});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 230,
        width: 270,
        child: Card(
          child: Hero(
            tag: offer_name,
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Offer(
                              category: offer['category']['name'],
                              offer: offer,
                            )),
                  );
                },
                child: GridTile(
                    footer: Container(
                      color: Colors.white70,
                      child: ListTile(
                        leading: Text(offer_name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        title: Text(offer_date,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    child: Image.memory(
                      offer_picture,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
        ));
  }
}
