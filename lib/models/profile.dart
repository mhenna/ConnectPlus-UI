class Profile {
  String username;
  String email;
  String phoneNumber;

  Profile({
    this.username,
    this.email,
    this.phoneNumber,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
