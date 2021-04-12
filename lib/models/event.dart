import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/image_file.dart';

import 'package:connect_plus/models/erg.dart';

class Event {
  String status;
  String sId;
  String name;
  String venue;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String onBehalfOf;
  AdminUser createdBy;
  ImageFile poster;
  AdminUser updatedBy;
  ERG erg;
  String id;
  String trivia;
  bool slider;

  Event({
    this.status,
    this.sId,
    this.name,
    this.venue,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.poster,
    this.updatedBy,
    this.onBehalfOf,
    this.erg,
    this.id,
    this.slider,
    this.trivia,
  });

  Event.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sId = json['_id'];
    name = json['name'];
    venue = json['venue'];
    onBehalfOf = json['onBehalfOf'];
    endDate = json['endDate'] != null
        ? DateTime.parse((json['endDate'])).toLocal()
        : null;
    startDate = json['startDate'] != null
        ? DateTime.parse((json['startDate'])).toLocal()
        : null;
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
    slider = json['slider'] ?? false;
    trivia = json['trivia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['venue'] = this.venue;
    data['onBehalfOf'] = this.onBehalfOf;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['slider'] = this.slider;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    if (this.poster != null) {
      data['poster'] = this.poster.toJson();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy.toJson();
    }
    if (this.erg != null) {
      data['erg'] = this.erg.toJson();
    }

    data['trivia'] = this.trivia;
    data['id'] = this.id;
    data['slider'] = this.slider;
    return data;
  }
}
