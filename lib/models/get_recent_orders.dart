import 'package:json_annotation/json_annotation.dart';

part 'get_recent_orders.g.dart';

@JsonSerializable()
class GetRecentOrders{

  @JsonKey(name: 'UserId')
  String userId;
    @JsonKey(name: 'Token')
  String token;


  GetRecentOrders(this.userId,this.token);

  factory GetRecentOrders.fromJson(Map<String, dynamic> json) => _$GetRecentOrdersFromJson(json);

   Map<String, dynamic> toJson() => _$GetRecentOrdersToJson(this);
}