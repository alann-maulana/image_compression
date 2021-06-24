library image_compression;

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'src/configuration.dart';
import 'src/image_file.dart';

export 'src/configuration.dart';
export 'src/image_file.dart';

// On Flutter, you can run this compression on background using isolates with
// ```dart
// ImageFileConfiguration param;
// var compressedImage = await compute(compress, param);
// ```
ImageFile compress(ImageFileConfiguration param) {
  final input = param.input;
  if (input.contentType == 'image/webp') return input;

  final config = param.config;
  final image = img.decodeImage(input.rawBytes);

  if (image != null) {
    List<int>? output;
    switch (config.outputType) {
      case OutputType.jpg:
        output = img.encodeJpg(image, quality: config.jpgQuality);
        break;
      case OutputType.png:
        output = img.encodePng(image, level: config.pngCompression.level);
        break;
    }

    input.rawBytes = Uint8List.fromList(output);
  } else {
    final animation = img.decodeAnimation(input.rawBytes);
    if (animation != null) {
      final output = img.encodeGifAnimation(
        animation,
        samplingFactor: config.animationGifSamplingFactor,
      );

      if (output != null) {
        input.rawBytes = Uint8List.fromList(output);
      }
    }
  }

  return input;
}

Future<ImageFile> compressInQueue(ImageFileConfiguration param) async {
  final input = param.input;
  final config = param.config;
  final completer = Completer<SendPort>();
  final completerResult = Completer<ImageFile>();

  final response = ReceivePort();
  await Isolate.spawn(_compressQueue, response.sendPort);
  response.listen((message) {
    if (message is SendPort) {
      completer.complete(message);
      response.close();
    }
  });

  final sendPort = await completer.future;
  final answer = ReceivePort();
  sendPort.send([
    answer.sendPort,
    ImageFileConfiguration(input: input, config: config),
  ]);
  answer.listen((message) {
    if (message is ImageFile) {
      completerResult.complete(message);
      answer.close();
    }
  });

  return await completerResult.future;
}

void _compressQueue(SendPort port) {
  final rPort = ReceivePort();
  port.send(rPort.sendPort);
  rPort.listen((message) {
    final send = message[0] as SendPort;
    final param = message[1] as ImageFileConfiguration;

    send.send(compress(param));
  });
}
