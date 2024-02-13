import 'package:flutter/cupertino.dart';

class RegistrationStatus {
  bool success;
  String error = "";
  RegistrationStatus({@required this.success, this.error});
}
