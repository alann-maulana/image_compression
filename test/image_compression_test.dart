import 'dart:io';

import 'package:test/test.dart';
import 'package:image_compression/image_compression.dart';

void main() {
  final file = File('/path/to/image/file.jpg');

  test('Compressing image synchronously', () {
    final input = ImageFile(
      rawBytes: file.readAsBytesSync(),
      filePath: file.path,
    );
    final output = compress(ImageFileConfiguration(input: input));
    expect(file.lengthSync() > output.sizeInBytes, isTrue);
    expect(output.contentType == 'image/jpeg', isTrue);
  });

  test('Compressing image asynchronously', () async {
    final inputSize = await file.length();
    final rawBytes = await file.readAsBytes();
    final input = ImageFile(
      rawBytes: rawBytes,
      filePath: file.path,
    );
    final output = await compressInQueue(ImageFileConfiguration(input: input));
    final outputSize = output.sizeInBytes;
    expect(inputSize > outputSize, isTrue);
  });
}
