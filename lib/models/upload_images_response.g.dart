// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_images_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImagesResponse _$UploadImagesResponseFromJson(Map<String, dynamic> json) {
  return UploadImagesResponse(
    json['OrderId'] as String,
    json['OrderNumber'] as String,
    (json['original'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UploadImagesResponseToJson(
        UploadImagesResponse instance) =>
    <String, dynamic>{
      'OrderId': instance.orderId,
      'OrderNumber': instance.orderNumber,
      'original': instance.original,
    };
