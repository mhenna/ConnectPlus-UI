class ERG {
  String color;
  String sId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String createdBy;
  String updatedBy;
  String id;

  ERG({
    this.color,
    this.sId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.updatedBy,
    this.id,
  });

  ERG.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    sId = json['_id'];
    name = json['name'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['id'] = this.id;
    return data;
  }
}
