import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class Auth with _$Auth {
  const factory Auth({
    @JsonKey(name: 'access_token') String? token,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) =>
      _$AuthFromJson(json);

  static Auth fromJsonFactory(Map<String, dynamic> json) => Auth.fromJson(json);
}