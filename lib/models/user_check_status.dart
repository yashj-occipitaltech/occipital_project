import 'package:json_annotation/json_annotation.dart';

part 'user_check_status.g.dart';

@JsonSerializable()

class UserCheckStatus{
  @JsonKey(name: 'Status')
  String status;

  @JsonKey(name: 'ResultCode')
  String resultCode;

  @JsonKey(name: 'Token',nullable: true)
  String token;

  UserCheckStatus(this.status,this.resultCode,this.token);


  factory UserCheckStatus.fromJson(Map<String, dynamic> json) => _$UserCheckStatusFromJson(json);

   Map<String, dynamic> toJson() => _$UserCheckStatusToJson(this);
}