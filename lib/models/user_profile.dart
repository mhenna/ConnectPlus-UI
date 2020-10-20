class UserProfile {
  String sId;
  String name;
  String email;
  String address;
  String carPlate;
  String phoneNumber;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String id;

  UserProfile({
    this.sId,
    this.name,
    this.email,
    this.address,
    this.carPlate,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.id,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    carPlate = json['carPlate'];
    phoneNumber = json['phoneNumber'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['carPlate'] = this.carPlate;
    data['phoneNumber'] = this.phoneNumber;
    data['createdAt'] = this.createdAt.toIso8601String();
    data['updatedAt'] = this.updatedAt.toIso8601String();
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
