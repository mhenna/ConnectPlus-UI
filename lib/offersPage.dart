import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyOffersPage extends StatefulWidget {
  MyOffersPage({Key key, this.title}) : super(key: key);
  final String title;
  // This widget is the root of your application.
  @override
  MyOffersPageState createState() => MyOffersPageState();
}
class MyOffersPageState extends State<MyOffersPage> {
//  String token;
  var ip;
  var port;

  void initState(){
    super.initState();
    setEnv();
    getCategories();

  }

  Future setEnv() async {
    await DotEnv().load('.env');
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];

  }
  void getCategories() async {
//    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
    var url = 'http://' + ip + ':' + port + '/offerCategories/getCategories';
    var oc;
    print(url);
    var response = await http.get(url,
        headers: {"Content-Type": "application/json"});
    print(response.statusCode);
    if(response.statusCode == 200)
      oc = json.decode(response.body)['offerCategories'];


    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(10, (index) {
            return Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.album),
                      title: Text('Offer name'),
                      subtitle: Text('Offer Details.'),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Learn more.'),
                          onPressed: () {/* ... */},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

    ));
  }
}