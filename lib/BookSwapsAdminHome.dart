import 'package:connect_plus/AdminComplaintsScreen.dart';
import 'package:connect_plus/BookSwapsAdminViewPosts.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart';
import 'login.dart';

class BookSwapsAdminHome extends StatefulWidget {
  final int selectedIndex;

  const BookSwapsAdminHome({Key key, this.selectedIndex = 0}) : super(key: key);

  @override
  _BookSwapsAdminHomeState createState() => _BookSwapsAdminHomeState();
}

class _BookSwapsAdminHomeState extends State<BookSwapsAdminHome> {
  int _selectedIndex;
  static List<Widget> _widgetOptions = <Widget>[
    BookSwapsAdminViewPosts(),
    AdminComplaintsScreen(),
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Book Swaps Admin'),
          backgroundColor: Utils.header,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () async {
                await sl<AuthService>().logout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
              },
            ),
          ],
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
          child: Container(
            child: _widgetOptions.elementAt(_selectedIndex),
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
                label: 'Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.support_agent),
                label: 'Complaints',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
