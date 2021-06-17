import 'dart:async';
import 'dart:isolate';

class TwoWayIsolate {
  void Function(dynamic)? onMain;
  dynamic Function(dynamic) onIsolate;
  String? debugName;
  bool running = false;
  bool launching = false;

  late SendPort toIsolate;
  late ReceivePort _toMain;
  late Isolate _isolate;
  
  TwoWayIsolate({
    this.onMain,
    required this.onIsolate,
    this.debugName,
  });

  void close() {
    _toMain.close();
    _isolate.kill();
  }

  void send(message) {
    toIsolate.send(message);
  }

  Future<void> initIsolate() async {
    launching = true;
    Completer completer = Completer();
    _toMain = ReceivePort();

    _toMain.listen((message) {
      if (message is SendPort) {
        toIsolate = message;
        completer.complete();
      } else {
        onMain!(message);
      }
    });

    _isolate = await Isolate.spawn(isolate, <String, dynamic>{ 'isolateToMainStream': _toMain.sendPort, 'onIsolate': onIsolate,}, debugName: debugName);
    running = false;
    return completer.future;
  }

  static void isolate(Map<String, dynamic> map) {
    ReceivePort mainToIsolateStream = ReceivePort();
    final SendPort isolateToMainStream = map['isolateToMainStream'];
    final onIsolate = map['onIsolate'];

    isolateToMainStream.send(mainToIsolateStream.sendPort);

    mainToIsolateStream.listen((message) {
      isolateToMainStream.send(onIsolate(message));
    });
  }
}
