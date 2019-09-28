// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_check_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCheckStatus _$UserCheckStatusFromJson(Map<String, dynamic> json) {
  return UserCheckStatus(
    json['Status'] as String,
    json['ResultCode'] as String,
    json['Token'] as String,
  );
}

Map<String, dynamic> _$UserCheckStatusToJson(UserCheckStatus instance) =>
    <String, dynamic>{
      'Status': instance.status,
      'ResultCode': instance.resultCode,
      'Token': instance.token,
    };
