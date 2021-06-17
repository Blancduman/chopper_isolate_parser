// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Product _$_$_ProductFromJson(Map<String, dynamic> json) {
  return _$_Product(
    id: json['id'] as int?,
    name: json['name'] as String?,
    cost: json['cost'] as int?,
    quantity: json['quantity'] as int?,
    locationId: json['locationId'] as int?,
    familyId: json['familyId'] as int?,
  );
}

Map<String, dynamic> _$_$_ProductToJson(_$_Product instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cost': instance.cost,
      'quantity': instance.quantity,
      'locationId': instance.locationId,
      'familyId': instance.familyId,
    };
