import 'package:flutter/widgets.dart';
import 'package:uber_clone_app/model/direction.dart';

class AppInfo with ChangeNotifier {
  Directions? userPickUpAddress , dropOfPickUpAddress;

  updatePickUpAddressLocation(Directions userPickUpAddress) {
    this.userPickUpAddress = userPickUpAddress;
    notifyListeners();
  }
   updateDropUpAddressLocation(Directions dropOfPickUpAddress) {
    this.dropOfPickUpAddress = dropOfPickUpAddress;
    notifyListeners();
  }
}
