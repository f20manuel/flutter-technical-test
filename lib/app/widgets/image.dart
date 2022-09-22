import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';

/// Network Image
class AppNetworkImage extends StatelessWidget {
  /// App Network Image Constructor
  const AppNetworkImage({
    required this.width,
    required this.path,
    this.placeholder,
    Key? key,
  }) : super(key: key);

  final String path;
  final ImageWidth width;
  final PlaceholderWidgetBuilder? placeholder;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
    imageUrl: '${dotenv.get('IMAGES_BASE_URL')}/${width.value}$path',
    placeholder: placeholder,
    width: width.value == 'original'
      ? MediaQuery.of(context).size.width
      : double.parse(width.value),
    height: MediaQuery.of(context).size.height,
    fit: width.value == 'original' ? BoxFit.cover : BoxFit.fitWidth,
  );
}
