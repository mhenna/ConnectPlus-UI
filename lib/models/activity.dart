import 'package:connect_plus/models/activityDate.dart';
import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';
import 'package:connect_plus/models/occurrence.dart';
import 'package:flutter/foundation.dart';

class Activity extends Occurrence {
  final String _recurrence;
  final ImageFile _poster;
  final String _sId;
  final String _name;
  final DateTime _startDate;
  final DateTime _endDate;
  final String _onBehalfOf;
  final String _venue;
  final String _zoomID;
  final String _days;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final int _iV;
  final AdminUser _createdBy;
  final AdminUser _updatedBy;
  final String _id;
  List<DateTime> recurrenceDates; // public as web_api breaks otherwise
  final ERG _erg;
  final List<ActivityDate> _activityDates;
  final bool _slider;

  @override
  String get name => _name;
  @override
  ImageFile get poster => _poster;
  @override
  DateTime get date => _createdAt;
  @override
  bool get slider => _slider;
  String get recurrence => _recurrence;
  String get sId => _sId;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  String get onBehalfOf => _onBehalfOf;
  String get venue => _venue;
  String get zoomID => _zoomID;
  String get days => _days;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
  int get iV => _iV;
  AdminUser get createdBy => _createdBy;
  AdminUser get updatedBy => _updatedBy;
  String get id => _id;
  ERG get erg => _erg;
  List<ActivityDate> get activityDates => _activityDates;

  Activity({
    @required String recurrence,
    @required ImageFile poster,
    @required String sId,
    @required String name,
    @required String onBehalfOf,
    @required DateTime startDate,
    @required DateTime endDate,
    @required String zoomID,
    @required String venue,
    @required String days,
    @required DateTime createdAt,
    @required DateTime updatedAt,
    @required int iV,
    @required this.recurrenceDates,
    @required AdminUser createdBy,
    @required AdminUser updatedBy,
    @required String id,
    @required ERG erg,
    @required List<ActivityDate> activityDates,
    @required bool slider,
  })  : _recurrence = recurrence,
        _poster = poster,
        _sId = sId,
        _name = name,
        _onBehalfOf = onBehalfOf,
        _startDate = startDate,
        _endDate = endDate,
        _zoomID = zoomID,
        _venue = venue,
        _days = days,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _iV = iV,
        _createdBy = createdBy,
        _updatedBy = updatedBy,
        _id = id,
        _erg = erg,
        _activityDates = activityDates,
        _slider = slider;

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      recurrence: json['recurrence'],
      poster:
          json['poster'] != null ? ImageFile.fromJson(json['poster']) : null,
      sId: json['_id'],
      name: json['name'],
      onBehalfOf: json['onBehalfOf'],
      zoomID: json['zoomID'],
      days: json['days'],
      recurrenceDates: json['recurrenceDates'] != null
          ? json['recurrenceDates'].cast<DateTime>()
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse((json['endDate'])).toLocal()
          : null,
      startDate: json['startDate'] != null
          ? DateTime.parse((json['startDate'])).toLocal()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse((json['createdAt']))
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse((json['updatedAt']))
          : null,
      venue: json['venue'],
      iV: json['__v'],
      createdBy: json['created_by'] != null
          ? new AdminUser.fromJson(json['created_by'])
          : null,
      updatedBy: json['updated_by'] != null
          ? new AdminUser.fromJson(json['updated_by'])
          : null,
      erg: json['erg'] != null ? new ERG.fromJson(json['erg']) : null,
      activityDates: List<Map<String, dynamic>>.from(json['activity_dates'])
          .map((activityDateJson) => ActivityDate.fromJson(activityDateJson))
          .toList(),
      id: json['id'],
      slider: json['slider'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recurrence'] = this._recurrence;
    if (this._poster != null) {
      data['poster'] = this._poster.toJson();
    }
    data['onBehalfOf'] = this._onBehalfOf;
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['startDate'] = this._startDate;
    data['endDate'] = this._endDate;
    data['venue'] = this._venue;
    data['zoomID'] = this._zoomID;
    data['days'] = this._days;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    if (this.recurrenceDates != null) {
      data['recurrenceDates'] = this.recurrenceDates;
    }
    data['__v'] = this._iV;
    if (this._createdBy != null) {
      data['created_by'] = this._createdBy.toJson();
    }
    if (this._updatedBy != null) {
      data['updated_by'] = this._updatedBy.toJson();
    }
    if (this._erg != null) {
      data['erg'] = this._erg.toJson();
    }
    if (this._activityDates != null) {
      data['activity_dates'] =
          this._activityDates.map((v) => v.toJson()).toList();
    }
    data['id'] = this._id;
    return data;
  }
}
