import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/attachment.dart';
import 'package:connect_plus/models/category.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';
import 'package:connect_plus/models/occurrence.dart';
import 'package:meta/meta.dart';

class Offer extends Occurrence {
  final String _sId;
  final String _name;
  final Category _category;
  final String _details;
  final String _discount;
  final DateTime _expiration;
  final String _contact;
  final DateTime _createdAt;
  final DateTime _updatedAt;
  final int _iV;
  final AdminUser _createdBy;
  final String _logo;
  final AdminUser _updatedBy;
  final String _location;
  final String _attachment;
  final String _id;
  final ERG _erg;
  final String _link;

  @override
  String get sId => _sId;
  @override
  String get name => _name;
  @override
  DateTime get date => _createdAt;
  @override
  String get poster => _logo;
  @override
  bool get slider => false;
  @override
  ERG get erg => _erg;
  Category get category => _category;
  String get details => _details;
  String get discount => _discount;
  DateTime get expiration => _expiration;
  String get contact => _contact;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;
  int get iV => _iV;
  AdminUser get createdBy => _createdBy;
  String get logo => _logo;
  AdminUser get updatedBy => _updatedBy;
  String get location => _location;
  String get attachment => _attachment;
  String get id => _id;
  String get link => _link;
  Offer({
    @required String sId,
    @required String name,
    @required Category category,
    @required String details,
    @required String discount,
    @required DateTime expiration,
    @required String contact,
    @required DateTime createdAt,
    @required DateTime updatedAt,
    @required int iV,
    @required AdminUser createdBy,
    @required String logo,
    @required AdminUser updatedBy,
    @required String location,
    @required String attachment,
    @required String id,
    @required ERG erg,
    String link,
  })  : _sId = sId,
        _name = name,
        _category = category,
        _details = details,
        _discount = discount,
        _expiration = expiration,
        _contact = contact,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _iV = iV,
        _createdBy = createdBy,
        _logo = logo,
        _updatedBy = updatedBy,
        _location = location,
        _attachment = attachment,
        _id = id,
        _erg = erg,
        _link = link;

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      sId: json['_id'],
      name: json['name'],
      category: json['category'] != null
          ? new Category.fromJson(json['category'])
          : null,
      details: json['details'],
      discount: json['discount'],
      expiration: json['expiration'] != null
          ? json['expiration'].toDate()
          : null,
      contact: json['contact'],
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
      logo: json['logo'] != null ? json['logo'] : null,
      updatedBy: json['updated_by'] != null
          ? new AdminUser.fromJson(json['updated_by'])
          : null,
      location: json['location'],
      attachment: json['attachment'] != null
          ? json['attachment']
          : null,
      id: json['id'],
      erg: json['erg'] != null ? ERG.fromJson(json['erg']) : null,
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['details'] = this._details;
    data['discount'] = this._discount;
    data['expiration'] = this._expiration.toIso8601String();
    data['contact'] = this._contact;
    data['createdAt'] = this._createdAt.toIso8601String();
    data['updatedAt'] = this._updatedAt.toIso8601String();
    data['__v'] = this._iV;
    if (this._createdBy != null) {
      data['created_by'] = this._createdBy.toJson();
    }
    if (this._logo != null) {
      data['logo'] = this._logo;
    }
    if (this._updatedBy != null) {
      data['updated_by'] = this._updatedBy.toJson();
    }
    data['location'] = this._location;
    if (this._attachment != null) {
      data['attachment'] = this._attachment;
    }
    if (this._category != null) {
      data['category'] = this._category.toJson();
    }
    if (this._erg != null) {
      data['erg'] = this._erg.toJson();
    }
    data['id'] = this._id;
    data['link'] = this._link;
    return data;
  }
}
