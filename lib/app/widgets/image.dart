import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';

/// Network Image
class AppNetworkImage extends StatelessWidget {
  /// App Network Image Constructor
  const AppNetworkImage({
    required this.pathWidth,
    required this.path,
    Key? key,
    this.placeholder,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  final String path;
  final ImageWidth pathWidth;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
    imageUrl: '${dotenv.get('IMAGES_BASE_URL')}/${pathWidth.value}$path',
    placeholder: placeholder,
    width: width,
    height: height,
    fit: fit,
  );
}
