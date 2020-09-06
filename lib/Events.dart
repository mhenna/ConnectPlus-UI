import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:connect_plus/Navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

class Events extends StatefulWidget {
  Events({
    Key key,
  }) : super(key: key);
  @override
  MyEventsPageState createState() => MyEventsPageState();
}

class MyEventsPageState extends State<Events>
    with AutomaticKeepAliveClientMixin<Events> {
  @override
  bool get wantKeepAlive => true;
//  String token;
  var ip;
  var port;
  var events = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    setEnv();
    getEvents();
  }

  Future setEnv() async {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getEvents() async {
    //    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
//    Working for android emulator -- set to actual ip for use with physical device
//    ip = "10.0.2.2";
//    port = '3300';
    var url = 'http://' + ip + ':' + port + '/event';
    var token = localStorage.getItem("token");
    print(url);
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    print(response.statusCode);
    if (response.statusCode == 200)
      setState(() {
        events = json.decode(response.body);
      });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(events.length);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0), // here the desired height
        child: AppBar(
          backgroundColor: const Color(0xfffafafa),
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1.0, 1.0),
                end: Alignment(1.0, -1.0),
                colors: [const Color(0xfff7501e), const Color(0xffed136e)],
                stops: [0.0, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text('All Events',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 28,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center),
            ),
          ),
          elevation: 0.0,
        ),
      ),
      drawer: NavDrawer(),
      backgroundColor: const Color(0xfffafafa),
      body: GridView.count(
        crossAxisCount: 1,
        addAutomaticKeepAlives: true,
        children: List.generate(
          events.length,
          (index) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x4d000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                              image: DecorationImage(
                                image: MemoryImage(base64Decode(events
                                    .elementAt(index)['poster']['fileData'])),
                              ),
                            ),
                          ),
                          Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Text(
                                      events
                                          .elementAt(index)['name']
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 18,
                                        color: const Color(0xfff23441),
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857142858,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      events.elementAt(index)['ERG'].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 15,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857142858,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      'Venue: ' +
                                          events
                                              .elementAt(index)['venue']
                                              .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857142858,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      'Start Date: ' +
                                          events
                                              .elementAt(index)['startDate']
                                              .toString()
                                              .substring(0, 10),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857142858,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      'End Date: ' +
                                          events
                                              .elementAt(index)['endDate']
                                              .toString()
                                              .substring(0, 10),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2857142857142858,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ]))
                        ],
                      )),
                ),
              ],
            ));
          },
        ),
      ),
    ));
  }
}
