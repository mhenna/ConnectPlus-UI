import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/material.dart';

import 'BookSwapsAdminHome.dart';
import 'BookSwapsHome.dart';
import 'models/BookPost.dart';
import 'models/BookRequest.dart';
import 'models/user.dart';

class BookPostInfoScreen extends StatelessWidget {
  final BookPost bookPost;
  final User currentUser;
  final BookSwapServices _bookSwapServices = new BookSwapServices();

  BookPostInfoScreen(
      {Key key, @required this.bookPost, @required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _requestBook() {
      showConfirmationPopUp(
          context: context,
          message: "Are you sure you want to request this book?",
          successMessage:
              "Book Requested Successfully. You will receive an email notification once ${bookPost.postedByFullName} accepts your request.",
          successMessageTitle: "Book Requested Successfully",
          onConfirmed: () async {
            await _bookSwapServices.addBookRequest(
                request: BookRequest(
                    postId: bookPost.postId,
                    bookName: bookPost.bookName,
                    requestedById: currentUser.id,
                    bookCategory: bookPost.bookCategory,
                    requestDuration: "3 Weeks",
                    bookDescription: bookPost.bookDescription,
                    bookPagesRange: bookPost.bookPagesRange,
                    postedById: bookPost.postedById,
                    requestStatus: BookRequestStatus.pendingUserApproval,
                    requestedByFullName: currentUser.username,
                    requestedByBU: currentUser.businessUnit,
                    requestedByEmail: currentUser.email,
                    bookCoverUrl: bookPost.bookCoverUrl,
                    postedByFullName: bookPost.postedByFullName,
                    postedByEmail: bookPost.postedByEmail));
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSwapsHome()),
            );
          });
    }

    _deletePost(){
      showConfirmationPopUp(
          context: context,
          message:
          "Are you sure you want to delete this post?",
          successMessage: "${bookPost.bookName} Deleted Successfully.",
          successMessageTitle: "Post Deleted Successfully",
          onConfirmed: () async {
            await _bookSwapServices.deleteBookPost(
                postId: bookPost.postId);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSwapsHome()),
            );
          });
    }

    _viewRequests(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookSwapsHome()),
      );
    }

    _adminAcceptBook() {
      showConfirmationPopUp(
          context: context,
          message:
              "Are you sure you approve ${bookPost.postedByFullName}'s book?",
          successMessage: "${bookPost.bookName} Approved Successfully.",
          successMessageTitle: "Book Approved Successfully",
          onConfirmed: () async {
            await _bookSwapServices.updatePostStatus(
                postId: bookPost.postId,
                status: BookPostStatus.approvedByAdmin);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSwapsAdminHome()),
            );
          });
    }

    _adminRejectBook() {
      showConfirmationPopUp(
          successMessageTitle: "Book Rejected Successfully",
          context: context,
          message:
              "Are you sure you reject ${bookPost.postedByFullName}'s book?",
          successMessage: "${bookPost.bookName} Rejected Successfully.",
          onConfirmed: () async {
            await _bookSwapServices.updatePostStatus(
                postId: bookPost.postId,
                status: BookPostStatus.approvedByAdmin);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSwapsAdminHome()),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Information'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                bookPost.bookCoverUrl,
                fit: BoxFit.cover,
                height: 300.0,
              ),
            ),
            SizedBox(height: 25.0),
            if (bookPost.postedById == currentUser.id)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Book Status:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  bookPostStatusValues[bookPost.postStatus],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
              ]),
            Text(
              'Book Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              bookPost.bookName,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Book Pages Range:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              bookPost.bookPagesRange,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Book Category:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              bookPost.bookCategory,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Book Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              bookPost.bookDescription,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Posted By:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '${bookPost.postedByFullName} (${bookPost.postedByBU} BU)',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Posted At:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              bookPost.postedAt,
              style: TextStyle(fontSize: 16.0),
            ),
            if (currentUser.customClaim == "bookSwapsAdmin")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(title: "Accept", onPress: _adminAcceptBook),
                    AppButton(title: "Reject", onPress: _adminRejectBook)
                  ],
                ),
              )
            else if (bookPost.postedById == currentUser.id)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (bookPost.postStatus != BookPostStatus.rejectedByAdmin &&
                          bookPost.postStatus !=
                              BookPostStatus.pendingAdminApproval)
                        AppButton(
                            title: "View Requests",
                            onPress: _viewRequests),
                      SizedBox(height: 10,),
                      AppButton(
                          title: "Delete Post", onPress: _deletePost)
                    ],
                  ),
                ),
              )
            else
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: AppButton(title: "Request", onPress: _requestBook),
                  ))
          ],
        ),
      ),
    );
  }
}
