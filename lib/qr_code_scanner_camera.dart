import 'dart:io' show Platform;
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:connect_plus/services/firestore_services.dart';

class QrCodeScannerCamera extends StatefulWidget {
  const QrCodeScannerCamera({Key key, @required this.eventId, @required this.eventName}) : super(key: key);
  final String eventId;
  final String eventName;
  @override
  State<QrCodeScannerCamera> createState() => _QrCodeScannerCameraState(this.eventId,this.eventName);
}

class _QrCodeScannerCameraState extends State<QrCodeScannerCamera> {
  final String eventId;
  final String eventName;
  _QrCodeScannerCameraState(this.eventId, this.eventName);
  String qrCode;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Set<String> scannedQrCodes={};
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('$eventName QR Code Scanning'),
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
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<void> _addEventRegistration(String uid) async {
    FirestoreServices fsServices=FirestoreServices();
    bool userExists=await fsServices.checkIfUserExists(uid);
    if(!userExists){
      _showMessage("Invalid QR Code!");
      return;
    }
    String username=await fsServices.getUsername(uid);
    bool userAlreadyRegistered=await fsServices.checkIfUserRegistered(uid,eventId);
    if(userAlreadyRegistered){
      _showMessage('$username was already added to the $eventName event');
      return;
    }
    fsServices.addUserEventRegistration(uid,eventId);
    _showMessage('$username has been added successfully to the $eventName event');
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode=scanData.code;
      });
      if(!scannedQrCodes.contains(qrCode)){
        _addEventRegistration(qrCode);
        scannedQrCodes.add(scanData.code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
