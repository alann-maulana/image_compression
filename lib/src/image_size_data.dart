import 'dart:typed_data';

/// Image formats supported by Flutter.
enum ImageFormat {
  /// A Portable Network Graphics format image.
  png,

  /// A JPEG format image.
  ///
  /// This library does not support JPEG 2000.
  jpeg,

  /// A WebP format image.
  webp,

  /// A Graphics Interchange Format image.
  gif,

  /// A Windows Bitmap format image.
  bmp,
}

/// Provides details about image format information for raw compressed bytes
/// of an image.
abstract class ImageSizeData {
  /// Allows subclasses to be const.
  const ImageSizeData({
    required this.format,
    required this.width,
    required this.height,
  })   : assert(width >= 0),
        assert(height >= 0);

  /// Creates an appropriate [ImageSizeData] for the source `bytes`, if possible.
  ///
  /// Only supports image formats supported by Flutter.
  static ImageSizeData? fromBytes(Uint8List? bytes) {
    if (bytes == null || bytes.isEmpty) {
      throw ArgumentError('bytes');
    } else if (PngImageSizeData.matches(bytes)) {
      return PngImageSizeData._(bytes.buffer.asByteData());
    } else if (JpegImageSizeData.matches(bytes)) {
      return JpegImageSizeData._fromBytes(bytes.buffer.asByteData());
    } else if (WebPImageSizeData.matches(bytes)) {
      return WebPImageSizeData._(bytes.buffer.asByteData());
    } else {
      return null;
    }
  }

  /// The [ImageFormat] this instance represents.
  final ImageFormat format;

  /// The width, in pixels, of the image.
  ///
  /// If the image is multi-frame, this is the width of the first frame.
  final int width;

  /// The height, in pixels, of the image.
  ///
  /// If the image is multi-frame, this is the height of the first frame.
  final int height;

  /// The esimated size of the image in bytes.
  ///
  /// The `withMipmapping` parameter controls whether to account for mipmapping
  /// when decompressing the image. Flutter will use this when possible, at the
  /// cost of slightly more memory usage.
  int decodedSizeInBytes({bool withMipmapping = true}) {
    if (withMipmapping) {
      return (width * height * 4.3).ceil();
    }
    return width * height * 4;
  }
}

/// The [ImageSizeData] for a PNG image.
class PngImageSizeData extends ImageSizeData {
  PngImageSizeData._(ByteData data)
      : super(
          format: ImageFormat.png,
          width: data.getUint32(16, Endian.big),
          height: data.getUint32(20, Endian.big),
        );

  /// Returns true if `bytes` starts with the expected header for a PNG image.
  static bool matches(Uint8List? bytes) {
    return bytes != null &&
        bytes.lengthInBytes > 20 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }
}

/// The [ImageSizeData] for a JPEG image.
///
/// This library does not support JPEG2000 images.
class JpegImageSizeData extends ImageSizeData {
  JpegImageSizeData._({required int width, required int height})
      : super(
          format: ImageFormat.jpeg,
          width: width,
          height: height,
        );

  static JpegImageSizeData? _fromBytes(ByteData data) {
    int index = 4; // Skip the first header bytes (already validated).
    index += data.getUint16(index, Endian.big);
    while (index < data.lengthInBytes) {
      if (data.getUint8(index) != 0xFF) {
        // Start of block
        throw StateError('Invalid JPEG file');
      }
      if (data.getUint8(index + 1) == 0xC0) {
        // Start of frame 0
        return JpegImageSizeData._(
          height: data.getUint16(index + 5, Endian.big),
          width: data.getUint16(index + 7, Endian.big),
        );
      }
      index += 2;
      index += data.getUint16(index, Endian.big);
    }
    return null;
  }

  /// Returns true if `bytes` starts with the expected header for a JPEG image.
  static bool matches(Uint8List? bytes) {
    return bytes != null &&
        bytes.lengthInBytes > 12 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
  }
}

/// The [ImageSizeData] for a WebP image.
class WebPImageSizeData extends ImageSizeData {
  WebPImageSizeData._(ByteData data)
      : super(
          format: ImageFormat.webp,
          width: data.getUint16(26, Endian.little),
          height: data.getUint16(28, Endian.little),
        );

  /// Returns true if `bytes` starts with the expected header for a WebP image.
  static bool matches(Uint8List? bytes) {
    return bytes != null &&
        bytes.lengthInBytes > 28 &&
        bytes[0] == 0x52 // R
        &&
        bytes[1] == 0x49 // I
        &&
        bytes[2] == 0x46 // F
        &&
        bytes[3] == 0x46 // F
        &&
        bytes[8] == 0x57 // W
        &&
        bytes[9] == 0x45 // E
        &&
        bytes[10] == 0x42 // B
        &&
        bytes[11] == 0x50; // P
  }
}
