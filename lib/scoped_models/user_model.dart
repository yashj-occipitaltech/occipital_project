import 'package:http/http.dart';
import 'package:occipital_tech/enums/view_state.dart';
import 'package:occipital_tech/models/store_user.dart';
import 'package:occipital_tech/models/user.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/models/verify_trader.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/result_codes.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  PublishSubject<bool> _userSubject = PublishSubject();
  PublishSubject<bool> _userExists = PublishSubject();

  User _authenticatedUser;
  bool isLoading = false;
  ViewState _state;

  //getters for private variables
  User get user => _authenticatedUser;
  PublishSubject<bool> get userSubject => _userSubject;
  PublishSubject<bool> get userExists => _userExists;
  ViewState get state => _state;

//Functions for login functionality
  Future<Map<String, dynamic>> checkUser(UserCheck user) async {
    _setState(ViewState.Busy);
    isLoading = true;
    final response = await ApiClient.checkUser(user);
    if (response.resultCode == ResultCodes.successCode) {
      _userExists.add(true);
    } else {
      _userExists.add(false);
    }
    isLoading = false;
    _setState(ViewState.Retrieved);

    return {"success": response.status};
  }

  Future<Map<String, dynamic>> storeUser(StoreUserData userData) async {
    _setState(ViewState.Busy);
    isLoading = true;
    bool hasError = true;
    final response = await ApiClient.storeUser(userData);

    if (response.resultCode == ResultCodes.successCode &&
        response.token != null) {
      _authenticatedUser = User(
          accessToken: response.token,
          userType: userData.userType,
          userName: userData.userName);
      _userSubject.add(true);
      _savePrefs(_authenticatedUser);
      hasError = false;
    } else if (response.resultCode == ResultCodes.successCode &&
        response.token == null) {
      hasError = true;
    }

    _setState(ViewState.Retrieved);
    isLoading = false;

    return {'success': !hasError, 'message': response.status};
  }

  Future<Map<String, dynamic>> verifyTrader(VerifyTrader data) async {
    _setState(ViewState.Busy);
    isLoading = true;
    bool isVerified = false;
    bool hasError = true;
    final response = await ApiClient.verifyTrader(data);

    if (response.resultCode == ResultCodes.successCode &&
        response.status == 'Success') {
      isVerified = true;    
      hasError = false;
    } else {
      isVerified = false;
      hasError = true;
    }

    _setState(ViewState.Retrieved);
    isLoading = false;

    return {'verified': isVerified, 'error': hasError,'status':response.status};
  }

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
     
      _authenticatedUser = User(
        accessToken: token,
      );
      _userSubject.add(true);
      notifyListeners();
    } else {
    
      _authenticatedUser = null;
      _userSubject.add(false);
      notifyListeners();
     
    }

    _setState(ViewState.Retrieved);
  }

  void _savePrefs(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userType', user.userType);
    //prefs.setString('phoneNo', user.phoneNo);
    prefs.setString('token', user.accessToken);
    prefs.setString('userName', user.userName);
  }

  void storePhoneNo(String phoneNo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNo', phoneNo);
  }

  void _deletePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('token');
    prefs.setString('userType', null);
    prefs.setString('phoneNo', null);
    prefs.setString('token', null);
    prefs.setString('userName', null);
  }

  void logout()async{
    _deletePrefs();
    _authenticatedUser = null;
    _userSubject.add(false);
    notifyListeners();
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void close() {
    _userSubject.close();
    _userExists.close();
  }
}
