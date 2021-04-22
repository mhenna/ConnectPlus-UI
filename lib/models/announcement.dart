import 'package:connect_plus/models/admin_user.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/image_file.dart';

class Announcement {
  String sId;
  String name;
  String description;
  DateTime deadline;
  DateTime createdAt;
  DateTime updatedAt;
  String onBehalfOf;
  AdminUser createdBy;
  ImageFile poster;
  AdminUser updatedBy;
  String id;
  String trivia;
  bool slider;
  String link;

  Announcement({
    this.sId,
    this.name,
    this.createdAt,
    this.description,
    this.deadline,
    this.onBehalfOf,
    this.updatedAt,
    this.createdBy,
    this.poster,
    this.updatedBy,
    this.id,
    this.slider,
    this.trivia,
    this.link,
  });

  Announcement.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    onBehalfOf = json['onBehalfOf'];
    description = json['description'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    deadline = json['deadline'] != null
        ? DateTime.parse((json['deadline'])).toLocal()
        : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    createdBy = json['created_by'] != null
        ? new AdminUser.fromJson(json['created_by'])
        : null;
    poster =
        json['poster'] != null ? new ImageFile.fromJson(json['poster']) : null;
    updatedBy = json['updated_by'] != null
        ? new AdminUser.fromJson(json['updated_by'])
        : null;
    id = json['id'];
    slider = json['slider'] ?? false;
    trivia = json['trivia']; // will auto set to null
    link = json['link']; // will auto set to null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['onBehalfOf'] = this.onBehalfOf;
    data['deadline'] = this.deadline;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['description'] = this.description;
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
    data['trivia'] = this.trivia;
    data['id'] = this.id;
    data['link'] = this.link;
    return data;
  }
}
