class UserWithToken {
  String jwt;
  User user;

  UserWithToken({this.jwt, this.user});

  UserWithToken.fromJson(Map<String, dynamic> json) {
    jwt = json['jwt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jwt'] = this.jwt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  bool confirmed;
  bool blocked;
  String sId;
  String username;
  String email;
  String phoneNumber;
  String provider;
  String createdAt;
  String updatedAt;
  int iV;
  Role role;
  String id;
  String carPlate;
  String businessUnit;
  String pushNotificationToken;

  User({
    this.confirmed,
    this.blocked,
    this.sId,
    this.username,
    this.email,
    this.phoneNumber,
    this.provider,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.role,
    this.id,
    this.carPlate,
    this.businessUnit,
    this.pushNotificationToken,
  });

  User.fromJson(Map<String, dynamic> json) {
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    provider = json['provider'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    id = json['id'];
    carPlate = json['carPlate'];
    businessUnit = json['businessUnit'];
    pushNotificationToken = json['pushNotificationToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirmed'] = this.confirmed;
    data['blocked'] = this.blocked;
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['provider'] = this.provider;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['carPlate'] = this.carPlate;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    data['id'] = this.id;
    data['businessUnit'] = this.businessUnit;
    data['pushNotificationToken'] = this.pushNotificationToken;
    return data;
  }

  User copyWith({
    bool confirmed,
    bool blocked,
    String sId,
    String username,
    String email,
    String phoneNumber,
    String provider,
    String createdAt,
    String updatedAt,
    int iV,
    Role role,
    String id,
    String carPlate,
    String businessUnit,
    String pushNotificationToken,
  }) {
    return User(
      confirmed: confirmed ?? this.confirmed,
      blocked: blocked ?? this.blocked,
      sId: sId ?? this.sId,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iV: iV ?? this.iV,
      role: role ?? this.role,
      id: id ?? this.id,
      carPlate: carPlate ?? this.carPlate,
      businessUnit: businessUnit ?? this.businessUnit,
      pushNotificationToken:
          pushNotificationToken ?? this.pushNotificationToken,
    );
  }
}

class Role {
  String sId;
  String name;
  String description;
  String type;
  String createdAt;
  String updatedAt;
  int iV;
  String id;

  Role(
      {this.sId,
      this.name,
      this.description,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  Role.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
