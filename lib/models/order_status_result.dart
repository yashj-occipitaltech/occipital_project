import 'package:json_annotation/json_annotation.dart';

part 'order_status_result.g.dart';

@JsonSerializable()
class OrderStatusResult{
  String commodityStatus;
  String markerStatus;
  String pdfStatus;
  String resultCode;
  String status;

  OrderStatusResult(this.commodityStatus,this.markerStatus,this.pdfStatus,this.resultCode,this.status);

  factory OrderStatusResult.fromJson(Map<String, dynamic> json) => _$OrderStatusResultFromJson(json);

   Map<String, dynamic> toJson() => _$OrderStatusResultToJson(this);

}