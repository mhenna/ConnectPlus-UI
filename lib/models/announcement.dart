import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';
import 'package:connect_plus/models/occurrence.dart';
import 'package:flutter/foundation.dart';

class Announcement extends Occurrence {
  final String _sId;
  final String _name;
  final String _description;
  final DateTime _deadline;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final String _onBehalfOf;
  final AdminUser _createdBy;
  final ImageFile _poster;
  final AdminUser _updatedBy;
  final String _id;
  final String _trivia;
  final bool _slider;
  final String _link;
  final ERG _erg;

  @override
  String get sId => _sId;
  @override
  String get name => _name;
  @override
  ImageFile get poster => _poster;
  @override
  bool get slider => _slider;
  @override
  DateTime get date => _createdAt;
  @override
  ERG get erg => _erg;
  String get description => _description;
  DateTime get deadline => _deadline;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
  String get onBehalfOf => _onBehalfOf;
  AdminUser get createdBy => _createdBy;

  AdminUser get updatedBy => _updatedBy;
  String get id => _id;
  String get trivia => _trivia;
  String get link => _link;

  Announcement({
    @required String sId,
    @required String name,
    @required DateTime createdAt,
    @required String description,
    @required DateTime deadline,
    @required String onBehalfOf,
    @required DateTime updatedAt,
    @required AdminUser createdBy,
    @required ImageFile poster,
    @required AdminUser updatedBy,
    @required String id,
    @required bool slider,
    @required String trivia,
    @required String link,
    @required ERG erg,
  })  : _sId = sId,
        _name = name,
        _createdAt = createdAt,
        _description = description,
        _deadline = deadline,
        _onBehalfOf = onBehalfOf,
        _updatedAt = updatedAt,
        _createdBy = createdBy,
        _poster = poster,
        _updatedBy = updatedBy,
        _id = id,
        _slider = slider,
        _trivia = trivia,
        _link = link,
        _erg = erg;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      sId: json['_id'],
      name: json['name'],
      onBehalfOf: json['onBehalfOf'],
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse((json['createdAt']))
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse((json['deadline'])).toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse((json['updatedAt']))
          : null,
      createdBy: json['created_by'] != null
          ? new AdminUser.fromJson(json['created_by'])
          : null,
      poster: json['poster'] != null
          ? new ImageFile.fromJson(json['poster'])
          : null,
      updatedBy: json['updated_by'] != null
          ? new AdminUser.fromJson(json['updated_by'])
          : null,
      id: json['id'],
      slider: json['slider'] ?? false,
      trivia:
          json['trivia'] == "" ? null : json['trivia'], // will auto set to null
      link: json['registrationLink'] ??
          json['link'] ??
          null, // will auto set to null
      erg: json['erg'] != null ? ERG.fromJson(json['erg']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['onBehalfOf'] = this._onBehalfOf;
    data['deadline'] = this._deadline;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['description'] = this._description;
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
    data['registrationLink'] = this._link;

    return data;
  }
}
