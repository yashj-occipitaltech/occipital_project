import 'package:json_annotation/json_annotation.dart';

part 'get_order_data.g.dart';

@JsonSerializable()
class GetOrderData {
  @JsonKey(name: 'OrderId')
  String orderId;
  @JsonKey(name: 'UserName')
  String userName;
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
  @JsonKey(name: 'ImageURLs')
  List<String> imageURLs;
  @JsonKey(name: 'Commodity')
  String commodity;
  @JsonKey(name: 'Samples')
  int samples;
  @JsonKey(name: 'OrderNumber')
  String ordernumber;
  @JsonKey(name: 'CommodityStatus')
  String commodityStatus;
  @JsonKey(name: 'PDFStatus')
  String pdfStatus;
  @JsonKey(name: 'MarkerStatus')
  String markerStatus;
  @JsonKey(name: 'ColorDetails')
  List<Map<String, double>> colorDetails;
  @JsonKey(name: 'Range')
  List range;
  @JsonKey(name: 'FrequencyArray')
  List<List> frequencyArray;
  @JsonKey(name: 'PDFPath')
  String pdfPath;
  @JsonKey(name: 'Defects')
  List<Map<String, dynamic>> defects;
  @JsonKey(name: 'Status')
  String status;
  @JsonKey(name: 'ResultCode')
  String resultCode;

  GetOrderData(
      this.orderId,
      this.userName,
      this.time,
      this.date,
      this.month,
      this.year,
      this.city,
      this.imageURLs,
      this.commodity,
      this.samples,
      this.ordernumber,
      this.commodityStatus,
      this.pdfStatus,
      this.markerStatus,
      this.colorDetails,
      this.range,
      this.frequencyArray,
      this.pdfPath,
      this.defects,
      this.status,
      this.resultCode);

  factory GetOrderData.fromJson(Map<String, dynamic> json) =>
      _$GetOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrderDataToJson(this);
}
