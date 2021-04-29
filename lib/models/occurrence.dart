import 'package:connect_plus/models/image_file.dart';

abstract class Occurrence {
  String get name;
  String get sId;
  ImageFile get poster;
  DateTime get date;
  bool get slider;
}
