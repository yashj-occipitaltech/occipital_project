// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusResult _$OrderStatusResultFromJson(Map<String, dynamic> json) {
  return OrderStatusResult(
    json['CommodityStatus'] as String,
    json['MarkerStatus'] as String,
    json['PDFStatus'] as String,
    json['ResultCode'] as String,
    json['Status'] as String,
  );
}

Map<String, dynamic> _$OrderStatusResultToJson(OrderStatusResult instance) =>
    <String, dynamic>{
      'CommodityStatus': instance.commodityStatus,
      'MarkerStatus': instance.markerStatus,
      'PDFStatus': instance.pdfStatus,
      'ResultCode': instance.resultCode,
      'Status': instance.status,
    };
