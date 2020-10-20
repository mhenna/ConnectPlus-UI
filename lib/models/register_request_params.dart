class RegisterRequestParameters {
  String username;
  String email;
  String password;

  RegisterRequestParameters({
    this.username,
    this.email,
    this.password,
  });

  RegisterRequestParameters.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
