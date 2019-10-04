import 'package:json_annotation/json_annotation.dart';

part 'order_status_check.g.dart';

@JsonSerializable()

class OrderStatusCheck{
  @JsonKey(name: 'OrderId')
  String orderId;
  @JsonKey(name: 'Token')
  String token;
  OrderStatusCheck(this.orderId,this.token);
  
  factory OrderStatusCheck.fromJson(Map<String, dynamic> json) => _$OrderStatusCheckFromJson(json);

   Map<String, dynamic> toJson() => _$OrderStatusCheckToJson(this);

}