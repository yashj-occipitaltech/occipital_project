import 'package:json_annotation/json_annotation.dart';

part 'user_check.g.dart';

@JsonSerializable()

class UserCheck{
  @JsonKey(name: 'MobileNumber')
  String mobileNumber;

  UserCheck(this.mobileNumber);


  factory UserCheck.fromJson(Map<String, dynamic> json) => _$UserCheckFromJson(json);

   Map<String, dynamic> toJson() => _$UserCheckToJson(this);
}