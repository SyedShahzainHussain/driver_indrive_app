import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestModel {
  LatLng? originLat;
  LatLng? destinationLat;
  String? originAddress;
  String? destinationAddress;
  String? riderRequestId;
  String? username;
  String? userphone;

  UserRideRequestModel({
    this.originLat,
    this.destinationLat,
    this.originAddress,
    this.destinationAddress,
    this.riderRequestId,
    this.username,
    this.userphone,
  });
}
