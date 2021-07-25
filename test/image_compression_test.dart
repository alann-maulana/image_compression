import 'dart:io';

import 'package:image_compression/src/png_compression.dart';
import 'package:test/test.dart';
import 'package:image_compression/image_compression.dart';

void main() async {
  final url = 'https://i.ibb.co/FbzvZWs/BLEvsNFC.jpg';
  final file = File('BLEvsNFC.jpg');
  if (!file.existsSync()) {
    print('Downloading jpg..');
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    print('Writing jpg file..');
    await response.pipe(file.openWrite());
  }

  final urlPng = 'https://i.ibb.co/6b5KdRm/BLEvsNFC.png';
  final filePng = File('BLEvsNFC.png');
  if (!filePng.existsSync()) {
    print('Downloading png..');
    final request = await HttpClient().getUrl(Uri.parse(urlPng));
    final response = await request.close();
    print('Writing png file..');
    await response.pipe(filePng.openWrite());
  }

  print('Starting tests..');
  test('Compressing jpg image synchronously', () {
    final input = ImageFile(
      rawBytes: file.readAsBytesSync(),
      filePath: file.path,
    );
    final output = compress(ImageFileConfiguration(input: input));
    expect(file.lengthSync() > output.sizeInBytes, isTrue);
    expect(output.contentType == 'image/jpeg', isTrue);
  });

  test('Compressing jpg image asynchronously', () async {
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

  test('Compressing png image synchronously', () {
    final input = ImageFile(
      rawBytes: filePng.readAsBytesSync(),
      filePath: filePng.path,
    );
    final output = compress(ImageFileConfiguration(
      input: input,
      config: const Configuration(
        outputType: OutputType.png,
      ),
    ));
    print('Input = ${filePng.lengthSync()}');
    print('Output = ${output.sizeInBytes}');
    expect(filePng.lengthSync() > output.sizeInBytes, isTrue);
    expect(output.extension == '.png', isTrue);
    expect(output.contentType == 'image/png', isTrue);
  });

  test('Compressing png image asynchronously', () async {
    final inputSize = await filePng.length();
    final rawBytes = await filePng.readAsBytes();
    final input = ImageFile(
      rawBytes: rawBytes,
      filePath: filePng.path,
    );
    final output = await compressInQueue(ImageFileConfiguration(
      input: input,
      config: const Configuration(
        outputType: OutputType.png,
        pngCompression: PngCompression.bestCompression,
      ),
    ));
    final outputSize = output.sizeInBytes;
    print('Input = $inputSize');
    print('Output = $outputSize');
    expect(inputSize > outputSize, isTrue);
  });
}
