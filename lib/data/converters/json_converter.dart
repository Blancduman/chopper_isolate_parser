import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:chopper_test/data/providers/json_provider.dart';

typedef T JsonFactory<T>(Map<String, dynamic> json);

class JSONConvertor implements Converter {
  final JsonProvider _jsonProvider = JsonProvider();
  bool get loading => _jsonProvider.runningIsolate;

  Future<void> initIsolate() async {
    await _jsonProvider.initIsolate();
  }

  void close() {
    _jsonProvider.close();
  }


  @override
  FutureOr<Request> convertRequest(Request request) {
    final req =
        applyHeader(request, contentTypeKey, jsonHeaders, override: false);
    return _jsonProvider.encodeJson(req);
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
      Response<dynamic> response) async {
    final Response<BodyType> result = await _jsonProvider.convertJsonResponse<BodyType, InnerType>(response);
    return result;
  }
}
