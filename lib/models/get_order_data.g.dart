// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrderData _$GetOrderDataFromJson(Map<String, dynamic> json) {
  return GetOrderData(
    json['OrderId'] as String,
    json['UserName'] as String,
    json['Time'] as String,
    json['Date'] as String,
    json['Month'] as String,
    json['Year'] as String,
    json['City'] as String,
    (json['ImageURLs'] as List)?.map((e) => e as String)?.toList(),
    json['Commodity'] as String,
    json['Samples'] as int,
    json['OrderNumber'] as int,
    json['CommodityStatus'] as String,
    json['PDFStatus'] as String,
    json['MarkerStatus'] as String,
    (json['ColorDetails'] as List)
        ?.map((e) => (e as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(k, (e as num)?.toDouble()),
            ))
        ?.toList(),
    json['Range'] as List,
    (json['FrequencyArray'] as List)?.map((e) => e as List)?.toList(),
    json['PDFPath'] as String,
    (json['ColorRGB'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    (json['Colors'] as List)?.map((e) => e as String)?.toList(),
    (json['Defects'] as List)
        ?.map((e) => (e as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(k, e as String),
            ))
        ?.toList(),
    json['Status'] as String,
    json['ResultCode'] as String,
    (json['TotalDefects'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$GetOrderDataToJson(GetOrderData instance) =>
    <String, dynamic>{
      'OrderId': instance.orderId,
      'UserName': instance.userName,
      'Time': instance.time,
      'Date': instance.date,
      'Month': instance.month,
      'Year': instance.year,
      'City': instance.city,
      'ImageURLs': instance.imageURLs,
      'Commodity': instance.commodity,
      'Samples': instance.samples,
      'OrderNumber': instance.ordernumber,
      'CommodityStatus': instance.commodityStatus,
      'PDFStatus': instance.pdfStatus,
      'MarkerStatus': instance.markerStatus,
      'ColorDetails': instance.colorDetails,
      'Range': instance.range,
      'FrequencyArray': instance.frequencyArray,
      'PDFPath': instance.pdfPath,
      'Colors': instance.colors,
      'ColorRGB': instance.colorRGB,
      'Defects': instance.defects,
      'Status': instance.status,
      'ResultCode': instance.resultCode,
      'TotalDefects': instance.totalDefects,
    };
