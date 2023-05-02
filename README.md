# Image Compression

A Dart Extension for image package to compress and resize the images.

If you want to build for Flutter, use [image_compression_flutter](https://pub.dev/packages/image_compression_flutter) package. It support native compression and WEBP format conversion (`Android` & `iOS` only).

## Sync Compression

```dart
import 'dart:io';

import 'package:image_compression/image_compression.dart';

void main() {
  final file = File('/path/to/image/file.jpg');

  final input = ImageFile(
    rawBytes: file.readAsBytesSync(),
    filePath: file.path,
  );
  final output = compress(ImageFileConfiguration(input: input));

  print('Input size = ${file.lengthSync()}');
  print('Output size = ${output.sizeInBytes}');
}
```

## Async Compression

```dart
import 'dart:io';

import 'package:image_compression/image_compression.dart';

void main() {
  final file = File('/path/to/image/file.jpg');

  final input = ImageFile(
    rawBytes: file.readAsBytesSync(),
    filePath: file.path,
  );
  final output = await compressInQueue(ImageFileConfiguration(input: input));

  print('Input size = ${file.lengthSync()}');
  print('Output size = ${output.sizeInBytes}');
}
```
