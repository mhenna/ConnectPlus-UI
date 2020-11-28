class EmergencyContact {
  String type;
  String sId;
  String name;
  String number;
  int iV;
  String id;

  EmergencyContact(
      {this.type, this.sId, this.name, this.number, this.iV, this.id});

  EmergencyContact.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    sId = json['_id'];
    name = json['name'];
    number = json['number'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['number'] = this.number;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
