import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chopper_test/data/constants/json_factories.dart';

class Chopper_Json {
  static dynamic convertFromJson(Type type, dynamic entity) {
    if (entity is Iterable) return _decodeList(type, entity);
    if (entity is Map)
      return _decodeMap(type, Map<String, dynamic>.from(entity));

    return entity;
  }

  static dynamic _decodeMap(Type type, Map<String, dynamic> value) {
    final converter = JsonFactories.factories[type];

    if (converter != null) {
      return converter(value);
    }
    throw ArgumentError('Unknown type');
  }

  static dynamic _decodeList(Type type, Iterable values) => values
      .where((v) => v != null)
      .map((v) => convertFromJson(type, v))
      .toList();

  static Request encodeJson(Request request) {
    var contentType = request.headers[contentTypeKey];
    if (contentType != null && contentType.contains(jsonHeaders)) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }
}