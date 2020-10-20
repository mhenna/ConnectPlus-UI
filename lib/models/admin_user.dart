class AdminUser {
  String sId;
  Null username;
  String firstname;
  String lastname;
  String createdAt;
  String updatedAt;
  int iV;
  String id;

  AdminUser(
      {this.sId,
      this.username,
      this.firstname,
      this.lastname,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  AdminUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
