import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';

class Webinar {
  String sId;
  String name;
  String url;
  double duration;
  DateTime startDate;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  AdminUser createdBy;
  ERG erg;
  ImageFile poster;
  AdminUser updatedBy;
  String id;
  bool isRecorded;

  Webinar(
      {this.sId,
      this.name,
      this.url,
      this.duration,
      this.startDate,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.createdBy,
      this.erg,
      this.poster,
      this.updatedBy,
      this.isRecorded,
      this.id});

  Webinar.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    url = json['url'];
    isRecorded = json['isRecorded'];
    duration = double.parse(json['Duration'].toString());
    startDate =
        json['startDate'] != null ? DateTime.parse((json['startDate'])) : null;
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdBy = json['created_by'] != null
        ? new AdminUser.fromJson(json['created_by'])
        : null;
    poster =
        json['poster'] != null ? new ImageFile.fromJson(json['poster']) : null;
    updatedBy = json['updated_by'] != null
        ? new AdminUser.fromJson(json['updated_by'])
        : null;
    erg = json['erg'] != null ? new ERG.fromJson(json['erg']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['Duration'] = this.duration;
    data['startDate'] = this.startDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isRecorded'] = this.isRecorded;

    data['__v'] = this.iV;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    if (this.erg != null) {
      data['erg'] = this.erg.toJson();
    }
    if (this.poster != null) {
      data['poster'] = this.poster.toJson();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}
