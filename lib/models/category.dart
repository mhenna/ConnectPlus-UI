import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/offer.dart';

class Category {
  String sId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  AdminUser createdBy;
  AdminUser updatedBy;
  String id;

  Category(
      {this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.createdBy,
      this.updatedBy,
      this.id});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;

    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy.toJson();
    }

    data['id'] = this.id;
    return data;
  }
}
