// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusCheck _$OrderStatusCheckFromJson(Map<String, dynamic> json) {
  return OrderStatusCheck(
    json['OrderId'] as String,
    json['Token'] as String,
  );
}

Map<String, dynamic> _$OrderStatusCheckToJson(OrderStatusCheck instance) =>
    <String, dynamic>{
      'OrderId': instance.orderId,
      'Token': instance.token,
    };
