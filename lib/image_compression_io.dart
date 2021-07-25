import 'dart:async';
import 'dart:isolate';

import 'package:image_compression/image_compression.dart' as c;

import 'src/configuration.dart';
import 'src/image_file.dart';

export 'src/configuration.dart';
export 'src/image_file.dart';

/// Compress image file input asynchronously
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

    send.send(c.compress(param));
  });
}
