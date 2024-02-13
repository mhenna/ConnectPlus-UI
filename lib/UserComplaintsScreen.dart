import 'package:connect_plus/SubmitComplaint.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/book_swap_services.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart';
import 'models/Complaint.dart';
import 'models/user.dart';

class UserComplaintsScreen extends StatefulWidget {
  @override
  _UserComplaintsScreenState createState() => _UserComplaintsScreenState();
}

class _UserComplaintsScreenState extends State<UserComplaintsScreen> {
  final BookSwapServices _bookSwapServices = new BookSwapServices();
  User user;
  List<Complaint> _complaints;

  @override
  void initState() {
    super.initState();
    setComplaints();
  }

  void setComplaints() async {
    user = await sl<AuthService>().user;
    List<Complaint> complaints =
        await _bookSwapServices.getUserComplaints(userId: user.id);
    setState(() {
      _complaints = complaints;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_complaints == null) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('My Complaints'),
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Utils.header,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitComplaint(
                    user: user,
                  ),
                ),
              );
            },
            tooltip: 'Add Complaint',
            child: Icon(Icons.add),
          ),
          body: _complaints.isEmpty
              ? Center(child: Text('No complaints found.'))
              : ListView.builder(
                  itemCount: _complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = _complaints[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          complaint.image.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Image.network(
                                    complaint.image,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : Container(),
                          Text(
                            complaint.referenceNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            complaint.time,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            complaint.text,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(thickness: 1),
                        ],
                      ),
                    );
                  },
                ));
  }
}
