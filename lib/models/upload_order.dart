import 'package:json_annotation/json_annotation.dart';

part 'upload_order.g.dart';

@JsonSerializable()

class UploadOrder{
  @JsonKey(name: 'User')
  String user;
  @JsonKey(name: 'Time')
  String time;
  @JsonKey(name: 'Date')
  String date;
  @JsonKey(name: 'Month')
  String month;
  @JsonKey(name: 'Year')
  String year;
  @JsonKey(name: 'City')
  String city;
  @JsonKey(name: 'Commodity')
  String commodity;
  @JsonKey(name: 'UserType')
  String userType;
  @JsonKey(name: 'Token')
  String token;
  @JsonKey(name:'descriptiomn')
  String description;
  

  UploadOrder(this.user,this.time,this.date,this.month,this.year,this.city,this.commodity,this.userType,this.token,this.description);
  factory UploadOrder.fromJson(Map<String, dynamic> json) => _$UploadOrderFromJson(json);

   Map<String, dynamic> toJson() => _$UploadOrderToJson(this);


}