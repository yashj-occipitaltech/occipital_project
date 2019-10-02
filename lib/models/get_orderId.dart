import 'package:json_annotation/json_annotation.dart';

part 'get_orderId.g.dart';

@JsonSerializable()
class GetOrderId{

  @JsonKey(name: 'UserId')
  String userId;
 @JsonKey(name: 'Month')
  String month;
   @JsonKey(name: 'Year')
  String year;
    @JsonKey(name: 'Token')
  String token;


  GetOrderId(this.userId,this.month,this.token,this.year);

  factory GetOrderId.fromJson(Map<String, dynamic> json) => _$GetOrderIdFromJson(json);

   Map<String, dynamic> toJson() => _$GetOrderIdToJson(this);
}