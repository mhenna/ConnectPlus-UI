import 'dart:io';
import 'package:connect_plus/UserComplaintsScreen.dart';
import 'package:connect_plus/models/Complaint.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/services/storage_services.dart';
import 'package:connect_plus/utils/pop_ups.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'models/user.dart';

class SubmitComplaint extends StatefulWidget {
  final User user;

  SubmitComplaint({@required this.user});
  @override
  _SubmitComplaintState createState() => _SubmitComplaintState();
}

class _SubmitComplaintState extends State<SubmitComplaint> {
  final _formKey = GlobalKey<FormState>();
  File _complaintImage;
  String _complaintText = '';
  final BookSwapServices _bookSwapServices = new BookSwapServices();
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _complaintImage = File(pickedImage.path);
    });
  }

  void _submitComplaint() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Perform submission logic here
      showAfterLoadingPopUp(
        context: context,
        loadingFunction: () async {
          Complaint complaint;
          if(_complaintImage != null) {
            String imageUrl =
            await uploadImageToFirebase('complaints', _complaintImage);
            complaint= new Complaint(userId: widget.user.id, fullName: widget.user.username,
                email: widget.user.email, image: imageUrl, text: _complaintText);
          }
          complaint= new Complaint(userId: widget.user.id, fullName: widget.user.username,
              email: widget.user.email, image: "", text: _complaintText);
          await _bookSwapServices.addComplaint(complaint:complaint );
        },
        successMessageTitle: "Complaint Submitted Successfully",
        successMessage:
        "Your complaint has been submitted successfully.",
        afterSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserComplaintsScreen()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Complaint'),
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
        padding: EdgeInsets.all(16.0),
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
                    height: _complaintImage == null ? 250.0 : 400,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        color: Colors.grey[400],
                      ),
                    ),
                    child: _complaintImage != null
                        ? Image.file(
                      _complaintImage,
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
              Text(
                'Optional: Add a photo referring to your complaint',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Complaint',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 10,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your complaint';
                  }
                  return null;
                },
                onSaved: (value) {
                  _complaintText = value;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: AppButton(
                  onPress: _submitComplaint,
                  title: 'Submit Complaint',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
