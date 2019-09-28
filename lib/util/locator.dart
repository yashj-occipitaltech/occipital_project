import 'package:get_it/get_it.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';

GetIt locator = GetIt.instance;


void setupLocator(){
locator.registerFactory<UserModel>(() =>UserModel());
}