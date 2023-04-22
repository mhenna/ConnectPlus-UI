import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/widgets/BookCard.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'BookPostInfoScreen.dart';
import 'PostBookScreen.dart';
import 'models/BookPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/injection_container.dart';

class BookSwapsHome extends StatefulWidget {
  @override
  _BookSwapsHomeState createState() => _BookSwapsHomeState();
}

class _BookSwapsHomeState extends State<BookSwapsHome> {
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
        .getAvailablePosts(currentUserId: currentUser.id);
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
        appBar: AppBar(
          title: Text('Available Book Posts'),
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
        body: _bookPosts.isEmpty
            ? Center(child: Text('No Available Posts'))
            : GridView.count(
                crossAxisCount: 2,
                children: List.generate(_bookPosts.length, (index) {
                  BookPost bookPost = _bookPosts[index];
                  return BookCard(
                      bookCoverUrl: bookPost.bookCoverUrl,
                      bookInfoText: 'Posted By: ${bookPost.postedByFullName}',
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
                builder: (context) => PostBookScreen(
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
