class UserProfileRequestParams {
  String username;
  String address;
  String carPlate;
  String phoneNumber;

  UserProfileRequestParams({
    this.username,
    this.address,
    this.carPlate,
    this.phoneNumber,
  });

  UserProfileRequestParams.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    address = json['address'];
    carPlate = json['carPlate'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['address'] = this.address;
    data['carPlate'] = this.carPlate;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
