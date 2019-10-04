// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusResult _$OrderStatusResultFromJson(Map<String, dynamic> json) {
  return OrderStatusResult(
    json['commodityStatus'] as String,
    json['markerStatus'] as String,
    json['pdfStatus'] as String,
    json['resultCode'] as String,
    json['status'] as String,
  );
}

Map<String, dynamic> _$OrderStatusResultToJson(OrderStatusResult instance) =>
    <String, dynamic>{
      'commodityStatus': instance.commodityStatus,
      'markerStatus': instance.markerStatus,
      'pdfStatus': instance.pdfStatus,
      'resultCode': instance.resultCode,
      'status': instance.status,
    };
