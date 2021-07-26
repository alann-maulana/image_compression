/// Library image compression
library image_compression;

import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'src/configuration.dart';
import 'src/image_file.dart';
import 'src/png_compression.dart';

export 'image_compression_html.dart'
    if (dart.library.io) 'image_compression_io.dart';
export 'src/configuration.dart';
export 'src/image_file.dart';
export 'src/png_compression.dart';

/// Compress image file input synchronously
///
/// On Flutter, you can run this compression on background using isolates with
/// ```dart
/// ImageFileConfiguration param;
/// var compressedImage = await compute(compress, param);
/// ```
ImageFile compress(ImageFileConfiguration param) {
  final input = param.input;
  if (input.contentType == 'image/webp') return input;

  final config = param.config;
  final image = img.decodeImage(input.rawBytes);

  if (image != null) {
    List<int>? output;
    switch (config.outputType) {
      case OutputType.jpg:
        output = img.encodeJpg(image, quality: config.jpgQuality);
        break;
      case OutputType.png:
        output = img.encodePng(image, level: config.pngCompression.level);
        break;
    }

    return ImageFile(
      filePath: '',
      rawBytes: Uint8List.fromList(output),
      width: image.width,
      height: image.height,
    );
  } else {
    final animation = img.decodeAnimation(input.rawBytes);
    if (animation != null) {
      final output = img.encodeGifAnimation(
        animation,
        samplingFactor: config.animationGifSamplingFactor,
      );

      if (output != null) {
        return ImageFile(
          filePath: '',
          rawBytes: Uint8List.fromList(output),
          width: animation.width,
          height: animation.height,
        );
      }
    }
  }

  return input;
}
