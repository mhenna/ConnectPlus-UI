import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';

class Activity {
  String recurrence;
  ImageFile poster;
  String sId;
  String name;
  DateTime startDate;
  DateTime endDate;
  String venue;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  AdminUser createdBy;
  AdminUser updatedBy;
  String id;
  ERG erg;

  Activity({
    this.recurrence,
    this.poster,
    this.sId,
    this.name,
    this.startDate,
    this.endDate,
    this.venue,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.erg,
  });

  Activity.fromJson(Map<String, dynamic> json) {
    recurrence = json['recurrence'];
    if (json['poster'] != null) {
      poster = new ImageFile.fromJson(json['poster']);
    }
    sId = json['_id'];
    name = json['name'];
    endDate =
        json['endDate'] != null ? DateTime.parse((json['endDate'])) : null;
    startDate =
        json['startDate'] != null ? DateTime.parse((json['startDate'])) : null;
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    venue = json['venue'];
    iV = json['__v'];
    createdBy = json['created_by'] != null
        ? new AdminUser.fromJson(json['created_by'])
        : null;
    updatedBy = json['updated_by'] != null
        ? new AdminUser.fromJson(json['updated_by'])
        : null;
    erg = json['erg'] != null ? new ERG.fromJson(json['erg']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recurrence'] = this.recurrence;
    if (this.poster != null) {
      data['poster'] = this.poster.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['venue'] = this.venue;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy.toJson();
    }
    if (this.erg != null) {
      data['erg'] = this.erg.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}
