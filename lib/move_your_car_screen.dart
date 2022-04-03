import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/car_plate_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/models/user.dart';

class MoveYourCarScreen extends StatefulWidget {
  @override
  _MoveYourCarScreenState createState() => _MoveYourCarScreenState();
}

class _MoveYourCarScreenState extends State<MoveYourCarScreen> {
  String _carPlate;

  Future<void> _sendNotification() async {
    _showLoading();
    final List<dynamic> response = await sl<PushNotificationsService>()
        .sendNotificationToCarOwner(carPlate: _carPlate);
    Navigator.pop(context);
    final NotificationResponse notificationResponse = response[0];
    final User blocker = response[1];

    if (notificationResponse == NotificationResponse.Success) {
      _showSuccess(blocker);
    } else if (notificationResponse == NotificationResponse.CarNotFound) {
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

  Future<void> _showSuccess(User blocker) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Notification Sent"),
          content: Text(
              "${blocker.username} from ${blocker.businessUnit} BU has been notified successfuly"),
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
              "Unfortunately this car is not registered for dell employees"),
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
