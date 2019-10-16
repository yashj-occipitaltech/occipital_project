import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:occipital_tech/models/get_orderId.dart';
import 'package:occipital_tech/models/get_order_data.dart';
import 'package:occipital_tech/models/get_recent_orders.dart';
import 'package:occipital_tech/models/order_status_check.dart';
import 'package:occipital_tech/models/order_status_result.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/models/store_user.dart';
import 'package:occipital_tech/models/upload_images_response.dart';
import 'package:occipital_tech/models/upload_order.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/models/user_check_status.dart';
import 'package:occipital_tech/models/verify_trader.dart';
import 'package:occipital_tech/util/consts.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Future<UserCheckStatus> checkUser(UserCheck user) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkUser,
        body: json.encode(user));
    //print(response.body.toString());
    return UserCheckStatus.fromJson(json.decode(response.body));
  }

  static Future<UserCheckStatus> storeUser(StoreUserData userData) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.storeUser,
        body: json.encode(userData));

    return UserCheckStatus.fromJson(json.decode(response.body));
  }

  static Future<UserCheckStatus> verifyTrader(VerifyTrader data) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.verifyTrader,
        body: json.encode(data));

    return UserCheckStatus.fromJson(json.decode(response.body));
  }

  static Future<OrdersData> getOrderIds(GetOrderId data) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.getOrderIds,
        body: json.encode(data));

    //print(response.body.toString());

    return OrdersData.fromJson(json.decode(response.body));
  }

  static Future<UploadImagesResponse> uploadImages(
      UploadOrder order, List<File> images) async {
    Dio dio = Dio();
    final uploader = FlutterUploader();
    String fileName = images[0].path.split('/').last;
    final Directory dir = await getApplicationDocumentsDirectory();
    final url = 'http://34.93.237.2${ApiEndpoints.uploadImages}';
    print(url);
      final String savedDir = '/storage/emulated/0/Android/data/com.occipitaltech.agrograde/files/Pictures/';
      print('---->');
      
      print(fileName);
      print(savedDir);
      print('---->');
    final task = await uploader.enqueue(
      url: url,
      method: UploadMethod.POST,
      files: [
        FileItem(
            filename: fileName,
            fieldname: 'uploads',
            savedDir: savedDir),
      ],
      data: order.toJson().cast<String,String>(),
    );
    print('--------------------------------------------------------------------------------->');
    print(task);
    // final subscription = uploader.progress.listen((progress) {
    //  // print(progress);
    //   //... code to handle progress
    // });
    
   // print(subscription);

    final uploadRequest = await dio.post(
        '${ApiEndpoints.baseUrl + ApiEndpoints.getOrderIds}',
        options: Options(method: 'POST'),
        data: FormData.fromMap({"uploads[]": ['/storage/emulated/0/Android/data/com.occipitaltech.agrograde/files/Pictures/']}));

    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.getOrderIds,
        body: json.encode(order));

   // print(uploadRequest.data.toString());
    // print(response.body.toString());

    return UploadImagesResponse.fromJson(json.decode(response.body));
  }

  static Future<OrderStatusResult> checkStatus(
      OrderStatusCheck orderStatus) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkOrderStatus,
        body: json.encode(orderStatus));

   

    return OrderStatusResult.fromJson(json.decode(response.body));
  }

  static Future<GetOrderData> getOrderData(OrderStatusCheck order) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.getOrderData,
        body: json.encode(order));

    print(GetOrderData.fromJson(json.decode(response.body)).defects);
    print(GetOrderData.fromJson(json.decode(response.body)).totalDefects);

    return GetOrderData.fromJson(json.decode(response.body));
  }

  static Future<OrdersData> getLastSomeOrders(GetRecentOrders order) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.getLastSomeOrders,
        body: json.encode(order));

    print(response.body.toString());

    return OrdersData.fromJson(json.decode(response.body));
  }

  // static Future<Map<String, dynamic>> getTokenandNumber() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString("token");
  //   String phoneNo = prefs.getString('phoneNo');
  //   return {"token": token, "phoneNo": phoneNo};
  // }
}
