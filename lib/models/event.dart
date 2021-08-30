import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/image_file.dart';

import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/occurrence.dart';
import 'package:flutter/foundation.dart';

class Event extends Occurrence {
  final String _status;
  final String _sId;
  final String _name;
  final String _venue;
  final DateTime _startDate;
  final DateTime _endDate;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final int _iV;
  final String _onBehalfOf;
  final AdminUser _createdBy;
  final ImageFile _poster;
  final AdminUser _updatedBy;
  final ERG _erg;
  final String _id;
  final String _trivia;
  final bool _slider;
  final String _link;
  @override
  DateTime get date => this._createdAt;

  @override
  String get name => this._name;

  @override
  ImageFile get poster => this._poster;

  @override
  String get sId => this._sId;

  @override
  bool get slider => this._slider;

  String get status => this._status;
  String get venue => this._venue;
  DateTime get startDate => this._startDate;
  DateTime get endDate => this._endDate;
  DateTime get createdAt => this._createdAt;
  DateTime get updatedAt => this._updatedAt;
  AdminUser get updatedBy => this._updatedBy;
  String get onBehalfOf => this._onBehalfOf;
  int get iV => this._iV;
  String get trivia => this._trivia;
  String get id => this._id;
  ERG get erg => this._erg;
  String get link => this._link;

  Event(
      {@required String sId,
      @required String status,
      @required String name,
      @required String venue,
      @required DateTime startDate,
      @required DateTime endDate,
      @required DateTime createdAt,
      @required DateTime updatedAt,
      @required int iV,
      @required String onBehalfOf,
      @required AdminUser createdBy,
      @required ImageFile poster,
      @required AdminUser updatedBy,
      @required ERG erg,
      @required String id,
      @required String trivia,
      @required bool slider,
      String link})
      : _sId = sId,
        _status = status,
        _name = name,
        _venue = venue,
        _startDate = startDate,
        _endDate = endDate,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _iV = iV,
        _onBehalfOf = onBehalfOf,
        _createdBy = createdBy,
        _poster = poster,
        _updatedBy = updatedBy,
        _erg = erg,
        _id = id,
        _trivia = trivia,
        _slider = slider,
        _link = link;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      status: json['status'],
      sId: json['_id'],
      name: json['name'],
      venue: json['venue'],
      onBehalfOf: json['onBehalfOf'],
      erg: json['erg'] != null ? ERG.fromJson(json['erg']) : null,
      id: json['id'],
      slider: json['slider'] ?? false,
      trivia: json['trivia'],
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
      iV: json['__v'],
      createdBy: json['created_by'] != null
          ? new AdminUser.fromJson(json['created_by'])
          : null,
      poster:
          json['poster'] != null ? ImageFile.fromJson(json['poster']) : null,
      updatedBy: json['updated_by'] != null
          ? AdminUser.fromJson(json['updated_by'])
          : null,
      link: json['registrationLink'] ?? json['link'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['venue'] = this._venue;
    data['onBehalfOf'] = this._onBehalfOf;
    data['startDate'] = this._startDate;
    data['endDate'] = this._endDate;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['__v'] = this._iV;
    data['slider'] = this._slider;
    if (this._createdBy != null) {
      data['created_by'] = this._createdBy.toJson();
    }
    if (this._poster != null) {
      data['poster'] = this._poster.toJson();
    }
    if (this._updatedBy != null) {
      data['updated_by'] = this._updatedBy.toJson();
    }
    if (this._erg != null) {
      data['erg'] = this._erg.toJson();
    }

    data['trivia'] = this._trivia;
    data['id'] = this._id;
    data['slider'] = this._slider;
    data['registrationLink'] = this._link;

    return data;
  }
}
