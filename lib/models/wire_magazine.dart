import 'package:connect_plus/models/attachment.dart';
import 'image_file.dart';

class WireMagazine {
   String sId;
   num edition;
   String pdf;
   String cover;

  WireMagazine({this.sId, this.edition, this.cover, this.pdf});

  WireMagazine.fromJson(Map<String, dynamic> json){
    sId=json['_id'];
    edition=json['magazineEdition'];
    cover=json['magazineCover']!= null ? json['magazineCover'] : null;
    pdf=json['magazinePDF']!= null ? json['magazinePDF'] : null;
  }
}
