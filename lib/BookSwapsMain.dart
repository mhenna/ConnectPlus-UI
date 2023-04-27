import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/firebase_functions_services.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BookSwapsAvailablePosts.dart';
import 'BookSwapsMyPosts.dart';
import 'BookSwapsMyRequests.dart';

import 'package:flutter/material.dart';

import 'injection_container.dart';
import 'models/user.dart';

class BookSwapsMain extends StatefulWidget {
  final int selectedIndex;

  const BookSwapsMain({Key key, this.selectedIndex = 0}) : super(key: key);

  @override
  _BookSwapsMainState createState() => _BookSwapsMainState();
}

class _BookSwapsMainState extends State<BookSwapsMain> {
  int _selectedIndex;
  static List<Widget> _widgetOptions = <Widget>[
    BookSwapsAvailablePosts(),
    BookSwapsMyPosts(),
    BookSwapsMyRequests(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Book Swaps'),
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
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: sl<AuthService>().getUser(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int points = snapshot.data.bookSwapPoints;
                    return Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('My Points: $points',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(flex: 12, child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFE0E0E0),
          selectedItemColor: Utils.secondaryColor,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Available Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'My Posts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: 'My Requests',
            ),
          ],
        ),
      ),
    );
  }
}
