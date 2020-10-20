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
    provider = json['providr'];
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
