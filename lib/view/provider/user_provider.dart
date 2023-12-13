import 'package:flutter/widgets.dart';
import 'package:uber_clone_app/model/user_model.dart';

class UserProvider with ChangeNotifier {
  DriversModel? _userModel;

  DriversModel? get user => _userModel;

  setUserModel(DriversModel? users) {
    _userModel = users;
    notifyListeners();
  }
}
