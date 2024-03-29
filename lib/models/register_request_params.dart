class RegisterRequestParameters {
  String username;
  String email;
  String password;
  String phoneNumber;

  RegisterRequestParameters(
      {this.username, this.email, this.password, this.phoneNumber});

  RegisterRequestParameters.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;

    return data;
  }
}
