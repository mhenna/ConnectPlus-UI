class LoginRequestParams {
  String identifier;
  String password;

  LoginRequestParams({
    this.identifier,
    this.password,
  });

  LoginRequestParams.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['password'] = this.password;
    return data;
  }
}
