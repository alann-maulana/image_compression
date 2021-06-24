import 'dart:typed_data';

import 'package:image_compression/image_compression.dart' as c;
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;

import 'configuration.dart';

class ImageFile {
  String filePath;
  Uint8List rawBytes;

  ImageFile({
    required this.filePath,
    required this.rawBytes,
  });

  int get sizeInBytes => rawBytes.lengthInBytes;

  String get fileName => path.basename(filePath);

  String get extension => path.extension(filePath);

  String? get contentType {
    return mime.lookupMimeType(
      filePath,
      headerBytes: List.from(rawBytes),
    );
  }

  // On Flutter, you can run this compression on background using isolates with
  // ```dart
  // ImageFile imageFile; Configuration config;
  // var compressedImage = await compute(imageFile.compress, config);
  // ```
  ImageFile compress([Configuration config = const Configuration()]) =>
      c.compress(ImageFileConfiguration(input: this, config: config));

  Future<ImageFile> compressInQueue([
    Configuration config = const Configuration(),
  ]) async {
    return c.compressInQueue(
      ImageFileConfiguration(input: this, config: config),
    );
  }
}
