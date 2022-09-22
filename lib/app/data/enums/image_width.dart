import 'package:flutter/foundation.dart';

/// Image Width Enum
enum ImageWidth {
  w100,
  w200,
  w300,
  w400,
  w500,
  original,
}

/// Extension for Image Width Enum
extension ImageWidthExtension on ImageWidth {
  String get value => describeEnum(this);
}