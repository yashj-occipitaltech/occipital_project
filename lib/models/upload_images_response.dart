import 'package:json_annotation/json_annotation.dart';


part 'upload_images_response.g.dart';

@JsonSerializable()

class UploadImagesResponse{
  @JsonKey(name: 'OrderId')
  String orderId;
  @JsonKey(name: 'OrderNumber')
  String orderNumber;
  List<String> original;

  UploadImagesResponse(this.orderId,this.orderNumber,this.original);

  factory UploadImagesResponse.fromJson(Map<String, dynamic> json) => _$UploadImagesResponseFromJson(json);

   Map<String, dynamic> toJson() => _$UploadImagesResponseToJson(this);
}