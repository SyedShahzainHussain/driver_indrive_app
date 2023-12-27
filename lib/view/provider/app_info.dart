import 'package:flutter/widgets.dart';
import 'package:uber_clone_app/model/direction.dart';
import 'package:uber_clone_app/model/trip_history_model.dart';

class AppInfo with ChangeNotifier {
  Directions? userPickUpAddress, dropOfPickUpAddress;
  int countTotalTrip = 0;
  List<String> tripKey = [];
  List<TripHistoryModel> tripHistory = [];
  String totalEarning = "";
  String totalRating = "";

  updatePickUpAddressLocation(Directions userPickUpAddress) {
    this.userPickUpAddress = userPickUpAddress;
    notifyListeners();
  }

  updateDropUpAddressLocation(Directions dropOfPickUpAddress) {
    this.dropOfPickUpAddress = dropOfPickUpAddress;
    notifyListeners();
  }

  updateCountTrip(int overAllTrip) {
    countTotalTrip = overAllTrip;
    notifyListeners();
  }

  updateAllOverUpdateTrip(List<String> tripKey) {
    this.tripKey = tripKey;
    notifyListeners();
  }

  updateAllOverUpdateTripInformation(TripHistoryModel tripHistoryModel) {
    tripHistory.add(tripHistoryModel);
    notifyListeners();
  }
  updateTotalEarning(String totalEarning) {
    this.totalEarning = totalEarning;
    notifyListeners();
  }
  updateTotalRating(String totalRating) {
    this.totalRating = totalRating;
    notifyListeners();
  }
}
