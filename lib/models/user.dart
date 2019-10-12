
class User{
  String phoneNo;
  String userType;
  String userName;
  String accessToken;
  int maxImages;
  List<String> commodities;

  User({this.accessToken,this.phoneNo,this.userName,this.userType,this.commodities,this.maxImages});
}