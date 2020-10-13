import 'package:connect_plus/models/user.dart';

class OfferCategory {
  final String _value;
  const OfferCategory._internal(this._value);
  const OfferCategory.fromString(this._value);
  toString() => '$_value';

  static const TECH = const OfferCategory._internal('tech');
  static const FOOD = const OfferCategory._internal('food');
  static const HEALTH = const OfferCategory._internal('health');

  static const asArray = const [TECH, FOOD, HEALTH];
}

class Offer {
  String sId;
  String name;
  OfferCategory category;
  String details;
  int discount;
  DateTime expiration;
  String contact;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  User createdBy;
  Logo logo;
  User updatedBy;
  String location;
  Attachment attachment;
  String id;

  Offer({
    this.sId,
    this.name,
    this.category,
    this.details,
    this.discount,
    this.expiration,
    this.contact,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.logo,
    this.updatedBy,
    this.location,
    this.attachment,
    this.id,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'] != null
        ? OfferCategory.fromString(json['category'])
        : null;
    details = json['details'];
    discount = json['discount'];
    expiration = json['expiration'] != null
        ? DateTime.parse((json['expiration']))
        : null;
    contact = json['contact'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdBy = json['created_by'] != null
        ? new User.fromJson(json['created_by'])
        : null;
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    updatedBy = json['updated_by'] != null
        ? new User.fromJson(json['updated_by'])
        : null;
    location = json['location'];
    attachment = json['attachment'] != null
        ? new Attachment.fromJson(json['attachment'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['details'] = this.details;
    data['discount'] = this.discount;
    data['expiration'] = this.expiration.toIso8601String();
    data['contact'] = this.contact;
    data['createdAt'] = this.createdAt.toIso8601String();
    data['updatedAt'] = this.updatedAt.toIso8601String();
    data['__v'] = this.iV;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    if (this.logo != null) {
      data['logo'] = this.logo.toJson();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy.toJson();
    }
    data['location'] = this.location;
    if (this.attachment != null) {
      data['attachment'] = this.attachment.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Logo {
  String sId;
  String name;
  String alternativeText;
  String caption;
  String hash;
  String ext;
  String mime;
  double size;
  int width;
  int height;
  String url;
  Formats formats;
  String provider;
  List<String> related;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String createdBy;
  String updatedBy;
  String id;

  Logo({
    this.sId,
    this.name,
    this.alternativeText,
    this.caption,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.width,
    this.height,
    this.url,
    this.formats,
    this.provider,
    this.related,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.updatedBy,
    this.id,
  });

  Logo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    alternativeText = json['alternativeText'];
    caption = json['caption'];
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    formats =
        json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
    provider = json['provider'];
    related = json['related'].cast<String>();
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['alternativeText'] = this.alternativeText;
    data['caption'] = this.caption;
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    if (this.formats != null) {
      data['formats'] = this.formats.toJson();
    }
    data['provider'] = this.provider;
    data['related'] = this.related;
    data['createdAt'] = this.createdAt.toIso8601String();
    data['updatedAt'] = this.updatedAt.toIso8601String();
    data['__v'] = this.iV;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['id'] = this.id;
    return data;
  }
}

class Formats {
  Thumbnail thumbnail;
  Thumbnail small;

  Formats({this.thumbnail, this.small});

  Formats.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    small =
        json['small'] != null ? new Thumbnail.fromJson(json['small']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small.toJson();
    }
    return data;
  }
}

class Thumbnail {
  String name;
  String hash;
  String ext;
  String mime;
  int width;
  int height;
  double size;
  Null path;
  String url;

  Thumbnail({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.width,
    this.height,
    this.size,
    this.path,
    this.url,
  });

  Thumbnail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    width = json['width'];
    height = json['height'];
    size = json['size'];
    path = json['path'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['width'] = this.width;
    data['height'] = this.height;
    data['size'] = this.size;
    data['path'] = this.path;
    data['url'] = this.url;
    return data;
  }
}

class Attachment {
  String sId;
  String name;
  String alternativeText;
  String caption;
  String hash;
  String ext;
  String mime;
  double size;
  String url;
  String provider;
  Null width;
  Null height;
  List<String> related;
  DateTime createdAt;
  DateTime updatedAt;
  int iV;
  String createdBy;
  String updatedBy;
  String id;

  Attachment({
    this.sId,
    this.name,
    this.alternativeText,
    this.caption,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.provider,
    this.width,
    this.height,
    this.related,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.updatedBy,
    this.id,
  });

  Attachment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    alternativeText = json['alternativeText'];
    caption = json['caption'];
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    url = json['url'];
    provider = json['provider'];
    width = json['width'];
    height = json['height'];
    related = json['related'].cast<String>();
    createdAt =
        json['createdAt'] != null ? DateTime.parse((json['createdAt'])) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse((json['updatedAt'])) : null;
    iV = json['__v'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['alternativeText'] = this.alternativeText;
    data['caption'] = this.caption;
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['url'] = this.url;
    data['provider'] = this.provider;
    data['width'] = this.width;
    data['height'] = this.height;
    data['related'] = this.related;
    data['createdAt'] = this.createdAt.toIso8601String();
    data['updatedAt'] = this.updatedAt.toIso8601String();
    data['__v'] = this.iV;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['id'] = this.id;
    return data;
  }
}
