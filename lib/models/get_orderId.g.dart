// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_orderId.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrderId _$GetOrderIdFromJson(Map<String, dynamic> json) {
  return GetOrderId(
    json['UserId'] as String,
    json['Month'] as String,
    json['Token'] as String,
    json['Year'] as String,
  );
}

Map<String, dynamic> _$GetOrderIdToJson(GetOrderId instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'Month': instance.month,
      'Year': instance.year,
      'Token': instance.token,
    };
