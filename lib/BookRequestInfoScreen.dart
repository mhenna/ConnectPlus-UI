import 'package:connect_plus/BookSwapsMain.dart';
import 'package:connect_plus/BookSwapsMyRequests.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/material.dart';

import 'BookSwapsAdminViewPosts.dart';
import 'BookSwapsAvailablePosts.dart';
import 'models/BookRequest.dart';
import 'models/user.dart';

class BookRequestInfoScreen extends StatelessWidget {
  final BookRequest bookRequest;
  final BookSwapServices _bookSwapServices = new BookSwapServices();

  BookRequestInfoScreen({Key key, @required this.bookRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _deleteRequest() {
      showConfirmationPopUp(
          context: context,
          message: "Are you sure you want to delete this request?",
          successMessage:
              "${bookRequest.bookName} Request Deleted Successfully.",
          successMessageTitle: "Request Deleted Successfully",
          onConfirmed: () async {
            await _bookSwapServices.deleteBookRequest(
                requestId: bookRequest.requestId);
            if (bookRequest.requestStatus == BookRequestStatus.acceptedByUser ||
                bookRequest.requestStatus == BookRequestStatus.received)
              _bookSwapServices.updatePostStatus(
                  postId: bookRequest.postId,
                  status: BookPostStatus.approvedByAdmin);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 2)),
            );
          });
    }

    _confirmReceived() {
      showConfirmationPopUp(
          context: context,
          message:
              "Are you sure you want to confirm that you have received this book from ${bookRequest.postedByFullName}?",
          successMessage:
              "Thank you for confirming that you've received this book. Enjoy!",
          successMessageTitle: "Book Marked as Received Successfully",
          onConfirmed: () async {
            await _bookSwapServices.updateRequestStatus(
                requestId: bookRequest.requestId,
                status: BookRequestStatus.received);
            await _bookSwapServices.updatePostStatus(
                postId: bookRequest.postId, status: BookPostStatus.handedOver);
            _bookSwapServices.addHandOverTime(
                requestId: bookRequest.requestId);
          },
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BookSwapsMain(selectedIndex: 2)),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Book Request Information'),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Image.network(
                  bookRequest.bookCoverUrl,
                  fit: BoxFit.cover,
                  height: 300.0,
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                'Status:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                bookRequest.getRequestStatusString(),
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Posted By:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.postedByFullName}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Book Name:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.bookName}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Book Pages Range:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.bookPagesRange}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Book Category:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.bookCategory}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Book Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.bookDescription}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Requested At:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.requestedAt}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Requested Rental Duration:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${bookRequest.requestDuration}',
                style: TextStyle(fontSize: 18.0),
              ),
              if (bookRequest.requestStatus == BookRequestStatus.acceptedByUser)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: AppButton(
                      onPress: _confirmReceived,
                      title: 'Mark Book as Received',
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: AppButton(
                    onPress: _deleteRequest,
                    title: 'Delete Request',
                  ),
                ),
              ),
            ])));
  }
}
