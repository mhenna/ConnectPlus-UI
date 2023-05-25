import 'dart:io';
import 'package:connect_plus/BookSwapsMain.dart';
import 'package:connect_plus/BookSwapsMyPosts.dart';
import 'package:connect_plus/models/BookPost.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/services/storage_services.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/utils/lists.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'BookSwapsAvailablePosts.dart';
import 'models/user.dart';

class BookSwapsPostBook extends StatefulWidget {
  final User currentUser;

  const BookSwapsPostBook({Key key, @required this.currentUser}) : super(key: key);

  @override
  _BookSwapsPostBookState createState() => _BookSwapsPostBookState(this.currentUser);
}

class _BookSwapsPostBookState extends State<BookSwapsPostBook> {
  final _formKey = GlobalKey<FormState>();
  String _bookTitle = '';
  String _bookCategory;
  String _bookDescription = '';
  String _bookPagesRange;
  File _bookImage;
  final BookSwapServices _bookSwapServices = new BookSwapServices();
  bool _bookImageNotSubmitted = false;
  final User currentUser;

  _BookSwapsPostBookState(this.currentUser);

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _bookImageNotSubmitted = false;
      _bookImage = File(pickedImage.path);
    });
  }

  void _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _addBookPost() async {
    if (_bookImage == null) {
      setState(() {
        _bookImageNotSubmitted = true;
      });
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_bookImageNotSubmitted) {
        _showMessage("Please upload a book cover");
      } else {
        showAfterLoadingPopUp(
          context: context,
          loadingFunction: () async {
            String bookCoverUrl =
                await uploadImageToFirebase('book-posts', _bookImage);
            BookPost bookPost = new BookPost(
                postedByFullName: currentUser.username,
                postedByEmail: currentUser.email,
                postedById: currentUser.id,
                postedByBU: currentUser.businessUnit,
                bookName: _bookTitle,
                bookPagesRange: _bookPagesRange,
                bookCategory: _bookCategory,
                bookDescription: _bookDescription,
                postStatus: BookPostStatus.pendingAdminApproval,
                bookCoverUrl: bookCoverUrl,
                borrowerFullName: "",
               );
            await _bookSwapServices.addBookPost(post: bookPost);
          },
          successMessageTitle: "Book Posted Successfully",
          successMessage:
              "Your book has been uploaded successfully. You will be notified once the admin approves your post.",
          afterSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSwapsMain(selectedIndex: 1)),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Book'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Container(
                      width: 250,
                      height: _bookImage == null ? 250.0 : 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.grey[400],
                        ),
                      ),
                      child: _bookImage != null
                          ? Image.file(
                              _bookImage,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              color: Colors.grey[400],
                              size: 60.0,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (_bookImage == null)
                  Center(
                    child: Text(
                      "Please upload an image of the Book Cover",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: _bookImageNotSubmitted
                              ? Colors.red
                              : Colors.black),
                    ),
                  ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Book Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a book title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _bookTitle = value;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  onTap: (){
                    FocusManager.instance.primaryFocus.unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'Book Pages Range',
                    border: OutlineInputBorder(),
                  ),
                  value: _bookPagesRange != null
                      ? bookPageRanges
                          .firstWhere((range) => range == _bookPagesRange)
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _bookPagesRange = value;
                    });
                  },
                  items: bookPageRanges
                      .map(
                        (range) => DropdownMenuItem<String>(
                          value: range,
                          child: Text(range),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose a book pages range';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Book Category',
                    border: OutlineInputBorder(),
                  ),
                  onTap: (){
                    FocusManager.instance.primaryFocus.unfocus();
                  },
                  value: _bookCategory != null
                      ? bookCategories.firstWhere(
                          (category) => category.toString() == _bookCategory)
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _bookCategory = value;
                    });
                  },
                  items: bookCategories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose a book category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Book Description',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 3,
                  maxLines: 10,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a book description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _bookDescription = value;
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                  child: AppButton(
                    onPress: _addBookPost,
                    title: 'Post Book',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
