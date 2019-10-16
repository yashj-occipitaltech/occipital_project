// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadOrder _$UploadOrderFromJson(Map<String, dynamic> json) {
  return UploadOrder(
    json['User'] as String,
    json['Time'] as String,
    json['Date'] as String,
    json['Month'] as String,
    json['Year'] as String,
    json['City'] as String,
    json['Commodity'] as String,
    json['UserType'] as String,
    json['Token'] as String,
    json['descriptiomn'] as String,
    json['Address'] as String,
  );
}

Map<String, dynamic> _$UploadOrderToJson(UploadOrder instance) =>
    <String, dynamic>{
      'User': instance.user,
      'Time': instance.time,
      'Date': instance.date,
      'Month': instance.month,
      'Year': instance.year,
      'City': instance.city,
      'Commodity': instance.commodity,
      'UserType': instance.userType,
      'Token': instance.token,
      'descriptiomn': instance.description,
      'Address': instance.address,
    };
