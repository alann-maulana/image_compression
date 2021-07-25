import 'dart:async';

import 'package:image_compression/image_compression.dart' as c;

import 'src/configuration.dart';
import 'src/image_file.dart';

/// Compress image file input asynchronously
Future<ImageFile> compressInQueue(ImageFileConfiguration param) async {
  return c.compress(param);
}
