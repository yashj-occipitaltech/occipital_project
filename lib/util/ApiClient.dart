import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:occipital_tech/models/get_orderId.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/models/store_user.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/models/user_check_status.dart';
import 'package:occipital_tech/models/verify_trader.dart';
import 'package:occipital_tech/util/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Future<UserCheckStatus> checkUser(UserCheck user) async {
    final response = await http.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkUser,
        body: json.encode(user));

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
