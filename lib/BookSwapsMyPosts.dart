import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/widgets/BookCard.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'BookPostInfoScreen.dart';
import 'BookSwapsPostBook.dart';
import 'models/BookPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/injection_container.dart';

class BookSwapsMyPosts extends StatefulWidget {
  @override
  _BookSwapsMyPostsState createState() => _BookSwapsMyPostsState();
}

class _BookSwapsMyPostsState extends State<BookSwapsMyPosts> {
  List<BookPost> _bookPosts;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    currentUser = await sl<AuthService>().user;
    List<BookPost> bookPosts = await BookSwapServices()
        .getUserPosts(userId: currentUser.id);
    setState(() {
      _bookPosts = bookPosts;
    });
  }

  void _navigateToPostInfo(BookPost bookPost) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BookPostInfoScreen(bookPost: bookPost, currentUser: currentUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bookPosts == null) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else {
      return Scaffold(
        body: _bookPosts.isEmpty
            ? Center(child: Text('No Current Posts'))
            : GridView.count(
          crossAxisCount: 1,
          children: List.generate(_bookPosts.length, (index) {
            BookPost bookPost = _bookPosts[index];
            return BookCard(
                bookCoverUrl: bookPost.bookCoverUrl,
                bookInfoText: 'Status: ${bookPostStatusValues[bookPost.postStatus]}',
                bookName: bookPost.bookName,
                onTap: () => _navigateToPostInfo(bookPost));
          }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Utils.header,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSwapsPostBook(
                  currentUser: currentUser,
                ),
              ),
            );
          },
          tooltip: 'Add Book',
          child: Icon(Icons.add),
        ),
      );
    }
  }
}
