import 'package:json_annotation/json_annotation.dart';
part 'verify_trader.g.dart';

@JsonSerializable()
class VerifyTrader {
  @JsonKey(name: 'CompanyId')
  String companyId;
  @JsonKey(name: 'Password')
  String password;

  VerifyTrader(this.companyId, this.password);

  factory VerifyTrader.fromJson(Map<String, dynamic> json) =>
      _$VerifyTraderFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyTraderToJson(this);
}
