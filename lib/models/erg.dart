import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/image_file.dart';
import 'package:connect_plus/models/webinar.dart';

class ERG {
  String color;
  String sId;
  String name;
  String description;
  int iV;
  ImageFile poster;

  String id;

  ERG(
      {this.color,
      this.sId,
      this.name,
      this.description,
      this.iV,
      this.poster,
      this.id});

  ERG.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    iV = json['__v'];

    if (json['poster'] != null) {
      poster = new ImageFile.fromJson(json['poster']);
    }

    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['__v'] = this.iV;

    if (this.poster != null) {
      data['poster'] = this.poster.toJson();
    }

    data['id'] = this.id;
    return data;
  }
}
