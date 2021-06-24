import 'image_file.dart';
import 'png_compression.dart';

enum OutputType { jpg, png }

class Configuration {
  final PngCompression pngCompression;
  final int jpgQuality;
  final int animationGifSamplingFactor;
  final OutputType outputType;

  const Configuration({
    this.pngCompression: PngCompression.defaultCompression,
    this.jpgQuality: 80,
    this.animationGifSamplingFactor = 30,
    this.outputType = OutputType.jpg,
  }) : assert(jpgQuality > 0 && jpgQuality <= 100);
}

class ImageFileConfiguration {
  ImageFileConfiguration({
    required this.input,
    this.config = const Configuration(),
  });

  final ImageFile input;
  final Configuration config;
}
