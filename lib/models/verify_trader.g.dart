// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_trader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTrader _$VerifyTraderFromJson(Map<String, dynamic> json) {
  return VerifyTrader(
    json['CompanyId'] as String,
    json['Password'] as String,
  );
}

Map<String, dynamic> _$VerifyTraderToJson(VerifyTrader instance) =>
    <String, dynamic>{
      'CompanyId': instance.companyId,
      'Password': instance.password,
    };
