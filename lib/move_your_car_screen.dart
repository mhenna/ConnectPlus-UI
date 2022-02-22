import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/car_plate_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoveYourCarScreen extends StatefulWidget {
  @override
  _MoveYourCarScreenState createState() => _MoveYourCarScreenState();
}

class _MoveYourCarScreenState extends State<MoveYourCarScreen> {
  String _carPlate;

  Future<void> _sendNotification() async {
    _showLoading();
    final NotificationResponse response = await sl<PushNotificationsService>()
        .sendNotificationToCarOwner(carPlate: _carPlate);
    Navigator.pop(context);
    if (response == NotificationResponse.Success) {
      _showSuccess();
    } else if (response == NotificationResponse.CarNotFound) {
      _showCarNotFound();
    } else {
      _showFailed();
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      builder: (context) {
        return ImageRotate.overlay();
      },
    );
  }

  Future<void> _showSuccess() {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Notification Sent"),
          content:
              Text("The owner of this vehicle has been notified successfuly"),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFailed() {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Failed"),
          content: Text("Could not send notification, please try again"),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCarNotFound() {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Not Found"),
          content: Text(
              "This car is not registered for dell employees, we have notified the facilities"),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Move Your Car"),
        centerTitle: true,
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
      drawer: NavDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: Utils.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Send a notification to:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 36),
            CarPlatePicker(
              onChanged: (String carPlate) {
                _carPlate = carPlate;
              },
            ),
            SizedBox(height: 36),
            SendButton(
              onPressed: () async {
                await _sendNotification();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final void Function() onPressed;
  const SendButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Utils.secondaryColor,
              Utils.primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        constraints: const BoxConstraints(
          maxHeight: 36,
          maxWidth: 240,
        ),
        alignment: Alignment.center,
        child: Text(
          "Send",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
