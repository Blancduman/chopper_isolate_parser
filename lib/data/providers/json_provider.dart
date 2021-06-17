import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chopper_test/data/providers/chopper_json_decoder.dart';
import 'package:chopper_test/utils/random_string.dart';
import 'package:chopper_test/utils/two_way_isolate.dart';

class JsonProvider {
  static TwoWayIsolate _twoWayIsolate = TwoWayIsolate(
    onIsolate: _onIsolate,
    debugName: 'JsonProvider',
  );

  final Map<String, Completer> _completers = {};
  final Map<String, Function(dynamic)> _callbacks = {};

  bool get runningIsolate => _twoWayIsolate.running || _twoWayIsolate.launching;

  static dynamic _onIsolate(message) {
    return {
      'id': message['id'],
      'payload': Chopper_Json.convertFromJson(
        message['type'],
        json.decode(message['body']),
      ),
    };
  }

  Request encodeJson(Request request) => Chopper_Json.encodeJson(request);

  Future<void> initIsolate() async {
    _twoWayIsolate.onMain = _onMain;
    await _twoWayIsolate.initIsolate();
  }

  dynamic _onMain(message) {
    String id = message['id'];
    final callback = _callbacks[id];
    _completers[id]!.complete(callback!(message['payload']));
    _completers.remove(id);
    _callbacks.remove(id);
  }

  Future<Response<BT>> convertJsonResponse<BT, IT>(Response<dynamic> response) {
    Completer<Response<BT>> completer = Completer<Response<BT>>();
    createJob<BT, IT>(completer, response);

    return completer.future;
  }

  void createJob<BT, IT>(Completer completer, Response<dynamic> response) {
    String id = getRandomString(16);
    _completers[id] = completer;
    _callbacks[id] = (data) {
      return response.copyWith<BT>(
        body: data is Iterable ? List<IT>.from(data) : data,
      );
    };

    _twoWayIsolate.send(<String, dynamic>{
      'id': id,
      'type': IT,
      'body': response.body,
    });
  }

  void close() {
    _twoWayIsolate.close();
  }
}
