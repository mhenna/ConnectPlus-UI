class UserProfileRequestParams {
  String name;
  String address;
  String carPlate;
  String phoneNumber;

  UserProfileRequestParams({
    this.name,
    this.address,
    this.carPlate,
    this.phoneNumber,
  });

  UserProfileRequestParams.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    carPlate = json['carPlate'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['carPlate'] = this.carPlate;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
