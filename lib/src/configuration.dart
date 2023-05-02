import 'image_file.dart';
import 'png_compression.dart';

/// The output type of image file
enum OutputType { jpg, png }

/// The configuration options for compressing image
class Configuration {
  /// The PNG compression quality
  final PngCompression pngCompression;

  /// The JPG compression quality
  final int jpgQuality;

  /// The animation GIF sampling factor
  final int animationGifSamplingFactor;

  /// The [OutputType] of image file
  final OutputType outputType;

  const Configuration({
    this.pngCompression = PngCompression.defaultCompression,
    this.jpgQuality = 80,
    this.animationGifSamplingFactor = 30,
    this.outputType = OutputType.jpg,
  }) : assert(jpgQuality > 0 && jpgQuality <= 100);
}

/// The wrapper object for [ImageFile] and [Configuration]
class ImageFileConfiguration {
  ImageFileConfiguration({
    required this.input,
    this.config = const Configuration(),
  });

  /// The input of image file
  final ImageFile input;

  /// The configuration options for compressing image
  final Configuration config;
}
