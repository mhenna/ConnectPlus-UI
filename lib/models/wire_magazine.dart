import 'package:connect_plus/models/attachment.dart';
import 'image_file.dart';

class WireMagazine {
   String sId;
   num edition;
   Attachment pdf;
   ImageFile cover;

  WireMagazine({this.sId, this.edition, this.cover, this.pdf});

  WireMagazine.fromJson(Map<String, dynamic> json){
    sId=json['_id'];
    edition=json['magazineEdition'];
    cover=json['magazineCover']!= null ? new ImageFile.fromJson(json['magazineCover']) : null;
    pdf=json['magazinePDF']!= null ? new Attachment.fromJson(json['magazinePDF']) : null;
  }
}
