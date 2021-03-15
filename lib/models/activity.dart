import 'package:connect_plus/models/activityDate.dart';
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
  String onBehalfOf;
  String venue;
  String zoomID;
  String days;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  AdminUser createdBy;
  AdminUser updatedBy;
  String id;
  List<DateTime> recurrenceDates;
  ERG erg;
  List<ActivityDate> activityDates;

  Activity({
    this.recurrence,
    this.poster,
    this.sId,
    this.name,
    this.onBehalfOf,
    this.startDate,
    this.endDate,
    this.zoomID,
    this.venue,
    this.days,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.recurrenceDates,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.erg,
    this.activityDates,
  });

  Activity.fromJson(Map<String, dynamic> json) {
    recurrence = json['recurrence'];
    if (json['poster'] != null) {
      poster = new ImageFile.fromJson(json['poster']);
    }
    sId = json['_id'];
    name = json['name'];
    onBehalfOf = json['onBehalfOf'];

    zoomID = json['zoomID'];
    days = json['days'];

    recurrenceDates = json['recurrenceDates'] != null
        ? json['recurrenceDates'].cast<DateTime>()
        : null;

    endDate =
        json['endDate'] != null ? DateTime.parse((json['endDate'])).toLocal() : null;
    startDate =
        json['startDate'] != null ? DateTime.parse((json['startDate'])).toLocal() : null;
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
    if (json['activity_dates'] != null) {
      activityDates = new List<ActivityDate>();
      json['activity_dates'].forEach((v) {
        activityDates.add(new ActivityDate.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recurrence'] = this.recurrence;
    if (this.poster != null) {
      data['poster'] = this.poster.toJson();
    }
    data['onBehalfOf'] = this.onBehalfOf;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['venue'] = this.venue;
    data['zoomID'] = this.zoomID;
    data['days'] = this.days;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.recurrenceDates != null) {
      data['recurrenceDates'] = this.recurrenceDates;
    }
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
    if (this.activityDates != null) {
      data['activity_dates'] =
          this.activityDates.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}
