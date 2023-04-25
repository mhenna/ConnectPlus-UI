import 'package:connect_plus/models/BookPost.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BookSwapsMain.dart';
import 'models/BookRequest.dart';

class BookSwapsViewRequests extends StatelessWidget {
  final BookPost bookPost;

  BookSwapsViewRequests({@required this.bookPost});

  final BookSwapServices _bookSwapServices = new BookSwapServices();

  @override
  Widget build(BuildContext context) {
    _confirmReturn(BookRequest bookRequest) {
      showConfirmationPopUp(
          context: context,
          message:
          "Are you sure you want to confirm that ${bookRequest.postedByFullName} has returned this book?",
          successMessage:
          "Book Marked as Returned Successfully. Please let us know if anything went wrong with your book's rental.",
          successMessageTitle: "Book Marked as Returned Successfully",
          onConfirmed: () async {
            await _bookSwapServices.updateRequestStatus(
                requestId: bookRequest.requestId,
                status: BookRequestStatus.returned);
            await _bookSwapServices.updatePostStatus(
                postId: bookRequest.postId,
                status: BookPostStatus.returned);
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
              "Are you sure that you want to accept ${bookRequest.postedByFullName}'s request?",
          successMessage:
              "Request Accepted Successfully. You can contact ${bookRequest.postedByFullName} via email (${bookRequest.requestedByEmail}) to discuss the hand over details.",
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
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 1)),
            );
          });
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 15),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${bookRequest.requestedByFullName}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text("${bookRequest.requestedByBU} BU"),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${bookRequest.requestedAt}"),
                            SizedBox(height: 3),
                            Text(
                                "Rent Duration: ${bookRequest.requestDuration}"),
                            SizedBox(height: 3),
                            Text(bookRequest.postedByEmail),
                          ],
                        ),
                        trailing: isBookAvailable
                            ? AppButton(
                                onPress: () {
                                  _acceptRequest(bookRequest);
                                },
                                title: 'Accept',
                              )
                            : isNotReturned
                                ? AppButton(
                                    onPress: () {
                                      _confirmReturn(bookRequest);
                                    },
                                    title: "Returned",
                                  )
                                : null,
                      ),
                    ),
                    Divider(thickness: 1)
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
