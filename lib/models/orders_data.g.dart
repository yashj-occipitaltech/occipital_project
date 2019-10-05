// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersData _$OrdersDataFromJson(Map<String, dynamic> json) {
  return OrdersData(
    (json['City'] as List)?.map((e) => e as String)?.toList(),
    (json['Commodity'] as List)?.map((e) => e as String)?.toList(),
    (json['CommodityStatus'] as List)?.map((e) => e as String)?.toList(),
    (json['Date'] as List)?.map((e) => e as String)?.toList(),
    (json['MarkerStatus'] as List)?.map((e) => e as String)?.toList(),
    (json['Month'] as List)?.map((e) => e as String)?.toList(),
    (json['OrderId'] as List)?.map((e) => e as String)?.toList(),
    json['OrderNumber'] as List,
    (json['PDFStatus'] as List)?.map((e) => e as String)?.toList(),
    json['ResultCode'] as String,
    json['Status'] as String,
    (json['Time'] as List)?.map((e) => e as String)?.toList(),
    (json['Year'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$OrdersDataToJson(OrdersData instance) =>
    <String, dynamic>{
      'City': instance.cities,
      'Commodity': instance.commodities,
      'CommodityStatus': instance.commodityStatus,
      'Date': instance.dates,
      'MarkerStatus': instance.markerStatuses,
      'Month': instance.months,
      'OrderId': instance.orderIds,
      'OrderNumber': instance.orderNumbers,
      'PDFStatus': instance.pdfStatuses,
      'Time': instance.times,
      'Years': instance.years,
      'ResultCode': instance.resultCode,
      'Status': instance.status,
    };
