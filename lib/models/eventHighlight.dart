import 'package:connect_plus/models/image_file.dart';

class EventHighlight {
  List<String> highlight;
  String sId;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String id;

  EventHighlight(
      {this.highlight,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  EventHighlight.fromJson(Map<String, dynamic> json) {
    if (json['highlight'] != null) {
      highlight = new List<String>();
      json['highlight'].forEach((v) {
        highlight.add(v);
      });
    }
    sId = json['_id'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.highlight != null) {
      data['highlight'] = this.highlight.map((v) => v).toList();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
