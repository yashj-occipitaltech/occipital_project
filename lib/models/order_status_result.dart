import 'package:json_annotation/json_annotation.dart';

part 'order_status_result.g.dart';

@JsonSerializable()
class OrderStatusResult{
  @JsonKey(name: 'CommodityStatus')
  String commodityStatus;
  @JsonKey(name: 'MarkerStatus')
  String markerStatus;
  @JsonKey(name: 'PDFStatus')
  String pdfStatus;
  @JsonKey(name: 'ResultCode')
  String resultCode;
  @JsonKey(name: 'Status')
  String status;

  OrderStatusResult(this.commodityStatus,this.markerStatus,this.pdfStatus,this.resultCode,this.status);

  factory OrderStatusResult.fromJson(Map<String, dynamic> json) => _$OrderStatusResultFromJson(json);

   Map<String, dynamic> toJson() => _$OrderStatusResultToJson(this);

}