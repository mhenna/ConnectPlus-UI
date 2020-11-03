import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/attachment.dart';
import 'package:connect_plus/models/image_file.dart';

class OfferCategory {
  final String _value;
  const OfferCategory._internal(this._value);
  const OfferCategory.fromString(this._value);
  toString() => '$_value';

  static const TECH = const OfferCategory._internal('tech');
  static const FOOD = const OfferCategory._internal('food');
  static const HEALTH = const OfferCategory._internal('health');

  static const asArray = const [TECH, FOOD, HEALTH];
}

class Offer {
  String sId;
  String name;
  OfferCategory category;
  String details;
  String discount;
  DateTime expiration;
  String contact;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  AdminUser createdBy;
  ImageFile logo;
  AdminUser updatedBy;
  String location;
  Attachment attachment;
  String id;

  Offer({
    this.sId,
    this.name,
    this.category,
    this.details,
    this.discount,
    this.expiration,
    this.contact,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.logo,
    this.updatedBy,
    this.location,
    this.attachment,
    this.id,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'] != null
        ? OfferCategory.fromString(json['category'])
        : null;
    details = json['details'];
    discount = json['discount'];
    expiration = json['expiration'] != null
        ? DateTime.parse((json['expiration']))
        : null;
    contact = json['contact'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdBy = json['created_by'] != null
        ? new AdminUser.fromJson(json['created_by'])
        : null;
    logo = json['logo'] != null ? new ImageFile.fromJson(json['logo']) : null;
    updatedBy = json['updated_by'] != null
        ? new AdminUser.fromJson(json['updated_by'])
        : null;
    location = json['location'];
    attachment = json['attachment'] != null
        ? new Attachment.fromJson(json['attachment'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['details'] = this.details;
    data['discount'] = this.discount;
    data['expiration'] = this.expiration.toIso8601String();
    data['contact'] = this.contact;
    data['createdAt'] = this.createdAt.toIso8601String();
    data['updatedAt'] = this.updatedAt.toIso8601String();
    data['__v'] = this.iV;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    if (this.logo != null) {
      data['logo'] = this.logo.toJson();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy.toJson();
    }
    data['location'] = this.location;
    if (this.attachment != null) {
      data['attachment'] = this.attachment.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}
