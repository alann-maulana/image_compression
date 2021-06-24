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
