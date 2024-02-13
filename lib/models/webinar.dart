import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';
import 'package:connect_plus/models/occurrence.dart';
import 'package:flutter/foundation.dart';

class Webinar extends Occurrence {
  final String _sId;
  final String _name;
  final String _url;
  final double _duration;
  final DateTime _startDate;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final String _onBehalfOf;
  final int _iV;
  final AdminUser _createdBy;
  final ERG _erg;
  final String _poster;
  final AdminUser _updatedBy;
  final String _id;
  final bool _isRecorded;
  final String _trivia;
  final bool _slider;

  @override
  String get sId => _sId;
  @override
  String get name => _name;
  @override
  String get poster => _poster;
  @override
  bool get slider => _slider;
  @override
  DateTime get date => _createdAt;

  String get url => _url;
  double get duration => _duration;
  DateTime get startDate => _startDate;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
  String get onBehalfOf => _onBehalfOf;
  int get iV => _iV;
  AdminUser get createdBy => _createdBy;
  AdminUser get updatedBy => _updatedBy;
  ERG get erg => _erg;
  String get id => _id;
  bool get isRecorded => _isRecorded;
  String get trivia => _trivia;

  Webinar({
    @required String sId,
    @required String name,
    @required String url,
    @required double duration,
    @required DateTime startDate,
    @required DateTime createdAt,
    @required String onBehalfOf,
    @required DateTime updatedAt,
    @required int iV,
    @required AdminUser createdBy,
    @required ERG erg,
    @required String poster,
    @required AdminUser updatedBy,
    @required bool isRecorded,
    @required String id,
    @required bool slider,
    @required String trivia,
  })  : _sId = sId,
        _name = name,
        _url = url,
        _duration = duration,
        _startDate = startDate,
        _createdAt = createdAt,
        _onBehalfOf = onBehalfOf,
        _updatedAt = updatedAt,
        _iV = iV,
        _createdBy = createdBy,
        _erg = erg,
        _poster = poster,
        _updatedBy = updatedBy,
        _isRecorded = isRecorded,
        _id = id,
        _slider = slider,
        _trivia = trivia;

  factory Webinar.fromJson(Map<String, dynamic> json) {
    return Webinar(
      sId: json['_id'],
      name: json['name'],
      url: json['url'],
      onBehalfOf: json['onBehalfOf'],
      isRecorded: json['isRecorded'],
      duration: json['Duration']!=null?double.parse(json['Duration'].toString()):0,
      startDate: json['startDate'] != null
          ? json['startDate'].toDate()
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
      poster: json['poster'] != null
          ? json['poster']
          : null,
      updatedBy: json['updated_by'] != null
          ? new AdminUser.fromJson(json['updated_by'])
          : null,
      erg: json['erg'] != null ? new ERG.fromJson(json['erg']) : null,
      id: json['id'],
      slider: json['slider'] ?? false,
      trivia: json['trivia'], // will auto set to null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['onBehalfOf'] = this._onBehalfOf;
    data['url'] = this._url;
    data['Duration'] = this._duration;
    data['startDate'] = this._startDate;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['isRecorded'] = this._isRecorded;
    data['slider'] = this._slider;
    data['__v'] = this._iV;
    if (this._createdBy != null) {
      data['created_by'] = this._createdBy.toJson();
    }
    if (this._erg != null) {
      data['erg'] = this._erg.toJson();
    }
    if (this._poster != null) {
      data['poster'] = this._poster;
    }
    if (this._updatedBy != null) {
      data['updated_by'] = this._updatedBy.toJson();
    }

    data['trivia'] = this._trivia;
    data['id'] = this._id;
    data['slider'] = this._slider;
    return data;
  }
}
