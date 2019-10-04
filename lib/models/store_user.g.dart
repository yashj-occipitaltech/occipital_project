// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreUserData _$StoreUserDataFromJson(Map<String, dynamic> json) {
  return StoreUserData(
    json['Date'] as String,
    json['Time'] as String,
    json['UserId'] as String,
    json['UserName'] as String,
    json['UserType'] as String,
    json['CompanyId'] as String,
    json['MailId'] as String,
    json['Month'] as String,
    json['Year'] as String,
  );
}

Map<String, dynamic> _$StoreUserDataToJson(StoreUserData instance) =>
    <String, dynamic>{
      'UserType': instance.userType,
      'UserName': instance.userName,
      'UserId': instance.userId,
      'Date': instance.date,
      'Time': instance.time,
      'CompanyId': instance.companyId,
      'MailId': instance.email,
      'Month': instance.month,
      'Year': instance.year,
    };
