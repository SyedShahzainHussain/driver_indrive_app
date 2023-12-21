import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/assistant/request_assistant.dart';
import 'package:uber_clone_app/model/direction.dart';
import 'package:uber_clone_app/model/distance_info_model.dart';
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
}
