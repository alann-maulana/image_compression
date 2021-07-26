import 'dart:typed_data';

import 'package:image_compression/image_compression.dart' as c;
import 'package:image_compression/image_compression_html.dart'
    if (dart.library.io) 'package:image_compression/image_compression_io.dart'
    as ci;
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;

import 'configuration.dart';
import 'image_size_data.dart';

/// The image file input for compressing
class ImageFile {
  /// The path of image file
  final String filePath;

  /// The raw bytes of image file
  final Uint8List rawBytes;

  String? _contentType;
  int? _width;
  int? _height;

  ImageFile({
    required this.filePath,
    required this.rawBytes,
    String? contentType,
    int? width,
    int? height,
  })  : _contentType = contentType,
        _width = width,
        _height = height {
    if (width == null && height == null) {
      ImageSizeData? imageSizeData;
      try {
        imageSizeData = ImageSizeData.fromBytes(rawBytes);
      } catch (_) {}

      _width = imageSizeData?.width;
      _height = imageSizeData?.height;
    }

    if (contentType == null) {
      _contentType = mime.lookupMimeType(
        filePath,
        headerBytes: List.from(rawBytes),
      );
    }
  }

  /// The size of image file input in bytes
  int get sizeInBytes => rawBytes.lengthInBytes;

  /// The name of image file input
  String get fileName => path.basename(filePath);

  /// The extension of image file input
  String get extension => path.extension(filePath);

  /// Return the content type of image file input if any
  String? get contentType => _contentType;

  /// Return the size of width from image
  int? get width => _width;

  /// Return the size of height from image
  int? get height => _height;

  /// Compress image file input synchronously
  ///
  /// On Flutter, you can run this compression on background using isolates with
  /// ```dart
  /// ImageFile imageFile; Configuration config;
  /// var compressedImage = await compute(imageFile.compress, config);
  /// ```
  ImageFile compress([Configuration config = const Configuration()]) =>
      c.compress(ImageFileConfiguration(input: this, config: config));

  /// Compress image file input asynchronously
  Future<ImageFile> compressInQueue([
    Configuration config = const Configuration(),
  ]) async {
    return ci.compressInQueue(
      ImageFileConfiguration(input: this, config: config),
    );
  }
}
