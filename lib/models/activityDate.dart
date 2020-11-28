import 'package:connect_plus/models/admin_user.dart';

class ActivityDate {
  String sId;
  String day;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String id;

  ActivityDate(
      {this.sId, this.day, this.createdAt, this.updatedAt, this.iV, this.id});

  ActivityDate.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    day = json['Day'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['Day'] = this.day;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
