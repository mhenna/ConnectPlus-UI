import 'package:connect_plus/BookSwapsMain.dart';
import 'package:connect_plus/BookSwapsViewRequests.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/services/firebase_functions_services.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/utils/lists.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/material.dart';

import 'BookSwapsAdminHome.dart';
import 'BookSwapsAdminViewPosts.dart';
import 'BookSwapsAvailablePosts.dart';
import 'injection_container.dart';
import 'models/BookPost.dart';
import 'models/BookRequest.dart';
import 'models/user.dart';

class BookPostInfoScreen extends StatefulWidget {
  final BookPost bookPost;
  final User currentUser;

  BookPostInfoScreen(
      {Key key, @required this.bookPost, @required this.currentUser})
      : super(key: key);

  @override
  _BookPostInfoScreenState createState() => _BookPostInfoScreenState();
}

class _BookPostInfoScreenState extends State<BookPostInfoScreen> {
  final BookSwapServices _bookSwapServices = new BookSwapServices();
  String _requestDuration = bookRentDurations[0]; // default value
  final FirebaseFunctionsServices _firebaseFunctionsServices =
      new FirebaseFunctionsServices();

  @override
  Widget build(BuildContext context) {
    _deletePost() {
      showConfirmationPopUp(
          context: context,
          message: "Are you sure you want to delete this post?",
          successMessage: "${widget.bookPost.bookName} Deleted Successfully.",
          successMessageTitle: "Post Deleted Successfully",
          onConfirmed: () async {
            await _bookSwapServices.deleteBookPost(
                postId: widget.bookPost.postId);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 1)),
            );
          });
    }

    _viewRequests() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BookSwapsViewRequests(bookPost: widget.bookPost)),
      );
    }

    _adminAcceptBook() {
      showConfirmationPopUp(
          context: context,
          message:
              "Are you sure you want to approve ${widget.bookPost.postedByFullName}'s book?",
          successMessage: "${widget.bookPost.bookName} Approved Successfully.",
          successMessageTitle: "Book Approved Successfully",
          onConfirmed: () async {
            await _bookSwapServices.updatePostStatus(
                postId: widget.bookPost.postId,
                status: BookPostStatus.approvedByAdmin);
            await _bookSwapServices.addBookSwapPoints(
                userId: widget.bookPost.postedById, points: 100);
            _firebaseFunctionsServices.sendEmail(
                receiverId: widget.bookPost.postedById,
                subject: "Connect+ Book Swaps | Book Post Approved By Admin",
                body: Utils.getComposedEmail(
                    fullName: widget.bookPost.postedByFullName,
                    emailBody:
                        """Congratulations! Your book "${widget.bookPost.bookName}" has been approved by the admin and is now available for users to request. As a reward, we have credited 100 Book Swaps Points to your account."""));
            sl<PushNotificationsService>().sendNotification(
                recipientId: widget.bookPost.postedById,
                notificationTitle: "Book Swaps | Book Post Approved By Admin",
                notificationBody:
                    """Your book "${widget.bookPost.bookName}" has been approved successfully by the admin.""",
                view: "book-swaps");
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
              "Are you sure you want to reject ${widget.bookPost.postedByFullName}'s book?",
          successMessage: "${widget.bookPost.bookName} Rejected Successfully.",
          onConfirmed: () async {
            await _bookSwapServices.updatePostStatus(
                postId: widget.bookPost.postId,
                status: BookPostStatus.rejectedByAdmin);
            _firebaseFunctionsServices.sendEmail(
                receiverId: widget.bookPost.postedById,
                subject: "Connect+ Book Swaps | Book Post Rejected By Admin",
                body: Utils.getComposedEmail(
                    fullName: widget.bookPost.postedByFullName,
                    emailBody:
                        'Your book "${widget.bookPost.bookName}" has been rejected by the admin. Please upload a book which is in compliance with our guidelines and policies.'));
            sl<PushNotificationsService>().sendNotification(
                recipientId: widget.bookPost.postedById,
                notificationTitle: "Book Swaps | Book Post Rejected By Admin",
                notificationBody:
                    'Your book "${widget.bookPost.bookName}" has been rejected by the admin. Please upload a book which is in compliance with our guidelines and policies.',
                view: "book-swaps");
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSwapsAdminHome()),
            );
          });
    }

    _requestBook() async {
      await showAfterLoadingPopUp(
          context: context,
          successMessage:
              "Book Requested Successfully. You will receive an email notification once ${widget.bookPost.postedByFullName} accepts your request.",
          successMessageTitle: "Book Requested Successfully",
          loadingFunction: () async {
            await _bookSwapServices.addBookRequest(
                request: BookRequest(
                    postId: widget.bookPost.postId,
                    bookName: widget.bookPost.bookName,
                    requestedById: widget.currentUser.id,
                    bookCategory: widget.bookPost.bookCategory,
                    requestDuration: _requestDuration,
                    bookDescription: widget.bookPost.bookDescription,
                    bookPagesRange: widget.bookPost.bookPagesRange,
                    postedById: widget.bookPost.postedById,
                    requestStatus: BookRequestStatus.pendingUserApproval,
                    requestedByFullName: widget.currentUser.username,
                    requestedByBU: widget.currentUser.businessUnit,
                    requestedByEmail: widget.currentUser.email,
                    bookCoverUrl: widget.bookPost.bookCoverUrl,
                    postedByFullName: widget.bookPost.postedByFullName,
                    postedByEmail: widget.bookPost.postedByEmail));
            _firebaseFunctionsServices.sendEmail(
                receiverId: widget.bookPost.postedById,
                subject: "Connect+ Book Swaps | New Book Request",
                body: Utils.getComposedEmail(
                    fullName: widget.bookPost.postedByFullName,
                    emailBody:
                        '${widget.currentUser.username} has requested your book "${widget.bookPost.bookName}". Please open the Book Swaps section in Connect+ and navigate to "My Posted Books -> View Requests" to be able to view the request.'));
            sl<PushNotificationsService>().sendNotification(
                recipientId: widget.bookPost.postedById,
                notificationTitle: "Book Swaps | New Book Request",
                notificationBody:
                    '${widget.currentUser.username} has requested your book "${widget.bookPost.bookName}".',
                view: "book-swaps");
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 2)),
            );
          });
    }

    _askForDuration() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );
      User user=await sl<AuthService>().getUser();
      Navigator.of(context).pop();
      if (user.bookSwapPoints >= 50) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Preferred Rental Duration:'),
              content: DropdownButtonFormField<String>(
                value: _requestDuration,
                icon: Icon(Icons.arrow_drop_down),
                onSaved: (String newValue) {
                  setState(() {
                    _requestDuration = newValue;
                  });
                },
                onChanged: (String newValue) {
                  setState(() {
                    _requestDuration = newValue;
                  });
                },
                items: bookRentDurations
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: _requestBook,
                ),
              ],
            );
          },
        );
      } else {
        Utils.showMessage(
            "You must have a minimum of 50 points to be able to request a book. Please post more books to gain points.");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Post Information'),
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
                widget.bookPost.bookCoverUrl,
                fit: BoxFit.cover,
                height: 300.0,
              ),
            ),
            SizedBox(height: 25.0),
            if (widget.bookPost.postedById == widget.currentUser.id)
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
                  widget.bookPost.getPostStatusString(),
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
              widget.bookPost.bookName,
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
              widget.bookPost.bookPagesRange,
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
              widget.bookPost.bookCategory,
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
              widget.bookPost.bookDescription,
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
              '${widget.bookPost.postedByFullName} (${widget.bookPost.postedByBU} BU)',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Posted At:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.bookPost.postedAt,
              style: TextStyle(fontSize: 16.0),
            ),
            if (widget.currentUser.customClaim == "bookSwapsAdmin")
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
            else if (widget.bookPost.postedById == widget.currentUser.id)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.bookPost.postStatus !=
                              BookPostStatus.rejectedByAdmin &&
                          widget.bookPost.postStatus !=
                              BookPostStatus.pendingAdminApproval)
                        AppButton(
                            title: "View Requests", onPress: _viewRequests),
                      SizedBox(
                        height: 10,
                      ),
                      AppButton(title: "Delete Post", onPress: _deletePost)
                    ],
                  ),
                ),
              )
            else
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child:
                        AppButton(title: "Request", onPress: _askForDuration),
                  ))
          ],
        ),
      ),
    );
  }
}
