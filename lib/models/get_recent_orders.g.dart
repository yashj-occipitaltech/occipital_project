// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_recent_orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRecentOrders _$GetRecentOrdersFromJson(Map<String, dynamic> json) {
  return GetRecentOrders(
    json['UserId'] as String,
    json['Token'] as String,
  );
}

Map<String, dynamic> _$GetRecentOrdersToJson(GetRecentOrders instance) =>
    <String, dynamic>{
      'UserId': instance.userId,
      'Token': instance.token,
    };
