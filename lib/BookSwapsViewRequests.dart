import 'package:connect_plus/models/BookPost.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/services/firebase_functions_services.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BookSwapsMain.dart';
import 'injection_container.dart';
import 'models/BookRequest.dart';

class BookSwapsViewRequests extends StatelessWidget {
  final BookPost bookPost;
  final _formKey = GlobalKey<FormState>();
  BookSwapsViewRequests({@required this.bookPost});

  final FirebaseFunctionsServices _firebaseFunctionsServices =
      new FirebaseFunctionsServices();
  final BookSwapServices _bookSwapServices = new BookSwapServices();
  String _rejectionText = '';

  @override
  Widget build(BuildContext context) {
    _confirmReturn(BookRequest bookRequest) {
      showConfirmationPopUp(
          context: context,
          message:
              "Are you sure you want to confirm that ${bookRequest.requestedByFullName} has returned this book?",
          successMessage:
              "Book Marked as Returned Successfully. Please let us know if anything went wrong with your book's rental.",
          successMessageTitle: "Book Marked as Returned Successfully",
          onConfirmed: () async {
            await _bookSwapServices.updateRequestStatus(
                requestId: bookRequest.requestId,
                status: BookRequestStatus.returned);
            await _bookSwapServices.updatePostStatus(
                postId: bookRequest.postId, status: BookPostStatus.returned);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 1)),
            );
          });
    }

    _acceptRequest(BookRequest bookRequest) {
      showConfirmationPopUp(
          context: context,
          message:
              "Are you sure you want to accept ${bookRequest.requestedByFullName}'s request?",
          successMessage:
              "Request Accepted Successfully. You can contact ${bookRequest.requestedByFullName} via email (${bookRequest.requestedByEmail}) to discuss the hand over details.",
          successMessageTitle: "Request Accepted Successfully",
          onConfirmed: () async {
            await _bookSwapServices.updateRequestStatus(
                requestId: bookRequest.requestId,
                status: BookRequestStatus.acceptedByUser);
            await _bookSwapServices.updatePostStatus(
                postId: bookRequest.postId,
                status: BookPostStatus.requestAccepted);
            await _bookSwapServices.updateBookBorrowerName(
                postId: bookRequest.postId,
                borrowerFullName: bookRequest.requestedByFullName);
            await _bookSwapServices.removeBookSwapPoints(
                userId: bookRequest.requestedById, points: 50);
            _firebaseFunctionsServices.sendEmail(
                receiverId: bookRequest.requestedById,
                subject: "Connect+ Book Swaps | Book Request Accepted",
                body: Utils.getComposedEmail(
                    fullName: bookRequest.requestedByFullName,
                    emailBody:
                        'Congratulations! ${bookPost.postedByFullName} has accepted your request for the book "${bookPost.bookName}". Feel free to discuss the hand over details with them. <span style="color:red;font-weight:bold;">Please update the status of the book to handed over from "My Requests -> Mark Book as Received" in the Book Swaps section of Connect+ once you receive the book.</span>'));
            sl<PushNotificationsService>().sendNotification(
                recipientId: bookRequest.requestedById,
                notificationTitle: "Book Swaps | Book Request Accepted",
                notificationBody:
                    '${bookPost.postedByFullName} has accepted your request for the book "${bookPost.bookName}".',
                view: "book-swaps");
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 1)),
            );
          });
    }

    _rejectRequest(BookRequest bookRequest) {
      if (_formKey.currentState.validate()) {
        showAfterLoadingPopUp(
          context: context,
          successMessage:
              "${bookRequest.requestedByFullName}'s Request Rejected Successfully.",
          successMessageTitle: "Request Rejected Successfully",
          loadingFunction: () async {
            await _bookSwapServices.updateRequestStatus(
                requestId: bookRequest.requestId,
                status: BookRequestStatus.rejectedByUser);
            _firebaseFunctionsServices.sendEmail(
                receiverId: bookRequest.requestedById,
                subject: "Connect+ Book Swaps | Book Request Rejected",
                body: Utils.getComposedEmail(
                    fullName: bookRequest.requestedByFullName,
                    emailBody:
                        '${bookPost.postedByFullName} has rejected your request for the book "${bookPost.bookName}". Rejection Reason: $_rejectionText.'));
            sl<PushNotificationsService>().sendNotification(
                recipientId: bookRequest.requestedById,
                notificationTitle: "Book Swaps | Book Request Rejected",
                notificationBody:
                    '${bookPost.postedByFullName} has rejected your request for the book "${bookPost.bookName}".',
                view: "book-swaps");
          },
          afterSuccess: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsViewRequests(bookPost:bookPost)),
            );
          });
      }
    }

    _askForRejectionReason(BookRequest bookRequest) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Rejection Reason'),
            content: Form(
              key:_formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(),
                ),
                minLines: 2,
                maxLines: 10,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the rejection reason';
                  }
                  return null;
                },
                onChanged: (value){
                  _rejectionText=value;
                },
              ),
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
                onPressed: () {
                  _rejectRequest(bookRequest);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${bookPost.bookName} Requests'),
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
      body: FutureBuilder<List<BookRequest>>(
        future: _bookSwapServices.getBookRequests(postId: bookPost.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ImageRotate(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text('No requests have been made for this book.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                BookRequest bookRequest = snapshot.data[index];
                bool isBookAvailable =
                    bookPost.postStatus == BookPostStatus.approvedByAdmin ||
                        bookPost.postStatus == BookPostStatus.returned;
                bool isNotReturned =
                    bookRequest.requestStatus == BookRequestStatus.received ||
                        bookRequest.requestStatus ==
                            BookRequestStatus.acceptedByUser;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${bookRequest.requestedByFullName}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(height: 5),
                                Text("${bookRequest.requestedByBU} BU",
                                    style: TextStyle(fontSize: 17)),
                                SizedBox(height: 5),
                                Text("${bookRequest.requestedAt}",
                                    style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 3),
                                Text(
                                    "Rent Duration: ${bookRequest.requestDuration}",
                                    style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 3),
                                Text(bookRequest.requestedByEmail,
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          if (isBookAvailable)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppButton(
                                  onPress: () {
                                    _acceptRequest(bookRequest);
                                  },
                                  title: 'Accept',
                                ),
                                SizedBox(height: 8),
                                AppButton(
                                  onPress: () {
                                    _askForRejectionReason(bookRequest);
                                  },
                                  title: 'Reject',
                                ),
                              ],
                            ),
                          if (!isBookAvailable && isNotReturned)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppButton(
                                  onPress: () {
                                    _confirmReturn(bookRequest);
                                  },
                                  title: "Confirm Return",
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
