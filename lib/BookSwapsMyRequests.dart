import 'package:connect_plus/homepage.dart';
import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/widgets/BookCard.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'BookPostInfoScreen.dart';
import 'BookRequestInfoScreen.dart';
import 'BookSwapsPostBook.dart';
import 'models/BookPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/injection_container.dart';

import 'models/BookRequest.dart';

class BookSwapsMyRequests extends StatefulWidget {
  @override
  _BookSwapsMyRequestsState createState() => _BookSwapsMyRequestsState();
}

class _BookSwapsMyRequestsState extends State<BookSwapsMyRequests> {
  List<BookRequest> _bookRequests;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    currentUser = await sl<AuthService>().user;
    List<BookRequest> bookRequests =
        await BookSwapServices().getUserRequests(userId: currentUser.id);
    setState(() {
      _bookRequests = bookRequests;
    });
  }

  void _navigateToRequestInfo(BookRequest bookRequest) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookRequestInfoScreen(bookRequest: bookRequest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bookRequests == null) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else {
      return Scaffold(
        body: _bookRequests.isEmpty
            ? Center(child: Text('No Current Requests'))
            : GridView.count(
                crossAxisCount: 1,
                children: List.generate(_bookRequests.length, (index) {
                  BookRequest bookRequest = _bookRequests[index];
                  return BookCard(
                      bookCoverUrl: bookRequest.bookCoverUrl,
                      bookInfoText:
                          'Status: ${bookRequest.getRequestStatusString()}',
                      bookName: bookRequest.bookName,
                      onTap: () => _navigateToRequestInfo(bookRequest));
                }),
              ),
      );
    }
  }
}
