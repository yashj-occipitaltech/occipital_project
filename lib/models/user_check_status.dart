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
  @JsonKey(name: 'UserType',nullable: true)
  String userType;
  @JsonKey(name: 'MaxImages')
  int maxImages;
  @JsonKey(name: 'Commodities')
  List<String> commodities;
  UserCheckStatus(this.status,this.resultCode,this.token,this.userType,this.commodities,this.maxImages);


  factory UserCheckStatus.fromJson(Map<String, dynamic> json) => _$UserCheckStatusFromJson(json);

   Map<String, dynamic> toJson() => _$UserCheckStatusToJson(this);
}