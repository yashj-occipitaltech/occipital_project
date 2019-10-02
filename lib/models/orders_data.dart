import 'package:json_annotation/json_annotation.dart';


part 'orders_data.g.dart';

@JsonSerializable()

class OrdersData{
  @JsonKey(name: "City")
  List<String> cities;
  @JsonKey(name: "Commodity")
  List<String> commodities;
  @JsonKey(name: "CommodityStatus")
  List<String> commodityStatus;
  @JsonKey(name: "Date")
  List<String> dates;
  @JsonKey(name: "MarkerStatus")
  List<String> markerStatuses;
  @JsonKey(name: "Month")
  List<String> months;
  @JsonKey(name: "OrderId")
  List<String> orderIds;
  @JsonKey(name: "OrderNumber")
  List<String> orderNumbers;
  @JsonKey(name: "PDFStatus")
  List<String> pdfStatuses;
  @JsonKey(name: "Time")
  List<String> times;
  @JsonKey(name: "ResultCode")
  String resultCode;
  @JsonKey(name: "Status")
  String status;
 

 OrdersData(this.cities,this.commodities,this.commodityStatus,this.dates,this.markerStatuses,this.months,this.orderIds,this.orderNumbers,this.pdfStatuses,this.resultCode,this.status,this.times);

 factory OrdersData.fromJson(Map<String, dynamic> json) => _$OrdersDataFromJson(json);

   Map<String, dynamic> toJson() => _$OrdersDataToJson(this);

}