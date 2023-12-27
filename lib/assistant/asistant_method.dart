import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/assistant/request_assistant.dart';
import 'package:uber_clone_app/model/direction.dart';
import 'package:uber_clone_app/model/distance_info_model.dart';
import 'package:uber_clone_app/model/trip_history_model.dart';
import 'package:uber_clone_app/model/user_model.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/view/provider/app_info.dart';
import 'package:uber_clone_app/view/provider/user_provider.dart';

class AsistantMethod {
  // ! geocode api
  static Future<String> searchAddressFromLangitudeandLatitude(
      Position position, BuildContext context) async {
    String humanReadableAddress = "";
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var requestResponse = await RequestAssistant.receivedRequest(apiUrl);
    if (requestResponse != "Error Occured, Failed. No Response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
      Directions userPickUpaddress = Directions();

      userPickUpaddress.locationLatitude = position.latitude;
      userPickUpaddress.locationLongitude = position.longitude;
      userPickUpaddress.locationName = humanReadableAddress;
      // ignore: use_build_context_synchronously
      context.read<AppInfo>().updatePickUpAddressLocation(userPickUpaddress);
    }
    return humanReadableAddress;
  }

// ! get user profile
  static void readCurrentOnlineUserInfo(BuildContext context) async {
    currentFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);
    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        DriversModel? users = DriversModel.fromJson(snap.snapshot);
        context.read<UserProvider>().setUserModel(users);
      }
    });
  }

// ! Direction APi

  static Future<DistanceInfoModel?> obtainedOriginToDestinationDirectionDetails(
    LatLng origin,
    LatLng destination,
  ) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey";
    var response = await RequestAssistant.receivedRequest(
      urlOriginToDestinationDirectionDetails,
    );

    if (response == "Error Occured, Failed. No Response") {
      return null;
    }
    DistanceInfoModel distanceInfoModel = DistanceInfoModel();
    distanceInfoModel.e_points =
        response['routes'][0]["overview_polyline"]["points"];

    distanceInfoModel.distance_text =
        response['routes'][0]["legs"][0]["distance"]["text"];
    distanceInfoModel.distance_value =
        response['routes'][0]["legs"][0]["distance"]["value"];

    distanceInfoModel.duration_text =
        response['routes'][0]["legs"][0]["duration"]["text"];

    distanceInfoModel.duration_value =
        response['routes'][0]["legs"][0]["duration"]["value"];

    return distanceInfoModel;
  }

// ! pauseDriverLiveLocation
  static pauseLiveLocation() async {
    streamSubscription!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

// ! resumeDriverLiveLocation
  static resumeLiveLocation() async {
    streamSubscription!.resume();
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      driverCurrentPositioned!.latitude,
      driverCurrentPositioned!.longitude,
    );
  }

// ! calculate the fare amount

  static double calculateFareAmount(DistanceInfoModel distanceInfoModel) {
    double timeTravaledFareAmoumtPerMinutes =
        (distanceInfoModel.duration_value! / 10) * 0.1;

    double timeTravaledFareAmoumtPerKilometer =
        (distanceInfoModel.duration_value! / 1000) * 0.1;

    double totalFare =
        timeTravaledFareAmoumtPerMinutes + timeTravaledFareAmoumtPerKilometer;

    double localCurrenyFareAmount = totalFare * 278.60;

    if (driverVehicleType == "bikes") {
      double resultFareAmount = (localCurrenyFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    } else if (driverVehicleType == "uber-go") {
      return localCurrenyFareAmount.truncate().toDouble();
    } else if (driverVehicleType == "uber-x") {
      double resultFareAmount = (localCurrenyFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return localCurrenyFareAmount.truncate().toDouble();
    }
  }

  // ! reterive trip keys for online driver

  static void readTripKeysOnlineDriver(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .orderByChild("driverId")
        .equalTo(currentFirebaseUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;
        // *  count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        context.read<AppInfo>().updateCountTrip(overAllTripsCounter);

        // * share the key with provider
        List<String> tripsKeyList = [];
        keysTripsId.forEach((key, value) {
          tripsKeyList.add(key);
        });
        context.read<AppInfo>().updateAllOverUpdateTrip(tripsKeyList);
        // !  get the trip keys
        readTripHistoryInformation(context);
      }
    });
  }

  static readTripHistoryInformation(BuildContext context) {
    var tripsAllKey = Provider.of<AppInfo>(context, listen: false).tripKey;
    for (String eachKey in tripsAllKey) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(eachKey)
          .once()
          .then((value) {
        var historyTrip = TripHistoryModel.fromSnapSHot(value.snapshot);
        // ! update allOverTripHistory

        if ((value.snapshot.value as Map)["status"] == "ended") {
          Provider.of<AppInfo>(context, listen: false)
              .updateAllOverUpdateTripInformation(historyTrip);
        }
      });
    }
  }
  // ! read driver earnings
  static void readDriverEarning(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("earning").once().then((value) {
          if(value.snapshot.value!=null) {
            String driverEarnings = value.snapshot.value as String;
             Provider.of<AppInfo>(context, listen: false)
              .updateTotalEarning(driverEarnings);
          }
        });
        readTripKeysOnlineDriver(context);
  }

  // ! read driver rating
    static void readDriverRating(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("ratings").once().then((value) {
          if(value.snapshot.value!=null) {
            String driverRating = value.snapshot.value as String;
             Provider.of<AppInfo>(context, listen: false)
              .updateTotalRating(driverRating);
          }
        });
  }
}
