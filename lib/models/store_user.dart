import 'package:json_annotation/json_annotation.dart';

part 'store_user.g.dart';

@JsonSerializable()
class StoreUserData{
  @JsonKey(name: 'UserType')
  String userType;
  @JsonKey(name: 'UserName')
  String userName;
  @JsonKey(name: 'UserId')
  String userId;
  @JsonKey(name: 'Date')
  String date;
  @JsonKey(name: 'Time')
  String time;
  @JsonKey(name: 'CompanyId')
  String companyId;
  @JsonKey(name: 'MailId')
  String email;

  StoreUserData(this.date,this.time,this.userId,this.userName,this.userType,this.companyId,this.email);
 
  factory StoreUserData.fromJson(Map<String, dynamic> json) => _$StoreUserDataFromJson(json);

   Map<String, dynamic> toJson() => _$StoreUserDataToJson(this);
}