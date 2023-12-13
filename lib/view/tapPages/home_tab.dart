import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone_app/assistant/asistant_method.dart';
import 'package:uber_clone_app/extension/screenWidthHeight/mediaquery.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:uber_clone_app/view/global/global.dart';

class HomeTapPage extends StatefulWidget {
  const HomeTapPage({super.key});

  @override
  State<HomeTapPage> createState() => _HomeTapPageState();
}

class _HomeTapPageState extends State<HomeTapPage> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? newGoogleMapController;
  LocationPermission? _locationPermission;
  Position? driverCurrentPositioned;

  String? statusText = "Now Offline";
  Color statusColor = Colors.grey;
  bool isDriverActive = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowes();
  }

  void blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  void checkIfLocationPermissionAllowes() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    } else {
      locateUserPositioned();
    }
  }

  void locateUserPositioned() async {
    Position cPosition = await Geolocator.getCurrentPosition();
    driverCurrentPositioned = cPosition;
    LatLng latLngPositioned = LatLng(
        driverCurrentPositioned!.latitude, driverCurrentPositioned!.longitude);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLngPositioned, zoom: 14)));
    // ignore: use_build_context_synchronously
    await AsistantMethod.searchAddressFromLangitudeandLatitude(
        driverCurrentPositioned!, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController googleMapController) {
                _googleMapController.complete(googleMapController);
                newGoogleMapController = googleMapController;
                blackThemeGoogleMap();
                locateUserPositioned();
              },
            ),
            // ! ui for online offline driver

            statusText == "Now Offline"
                ? Container(
                    height: context.screenHeight,
                    width: context.screenWidth,
                    color: Colors.black87,
                  )
                : Container(),

            Positioned(
              top:
                  statusText == "Now Offline" ? context.screenHeight * .45 : 25,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                      style:
                          FilledButton.styleFrom(backgroundColor: statusColor),
                      onPressed: () async {
                        if (isDriverActive != true) {
                          await driverIsOnlineNow();
                          await changeDriverLiveLocation();
                          setState(() {
                            statusText = "Now Online";
                            statusColor = Colors.black87;
                            isDriverActive = true;
                          });
                          Fluttertoast.showToast(msg: "you are Online now");
                        } else {
                          isDriverOffline();
                          setState(() {
                            statusText = "Now Offline";
                            statusColor = Colors.grey;
                            isDriverActive = false;
                          });
                          Fluttertoast.showToast(msg: "you are Offline now");
                        }
                      },
                      child: statusText == "Now Offline"
                          ? Text(
                              statusText!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                  ),
                            )
                          : const Icon(
                              Icons.phonelink_ring,
                              color: AppColors.whiteColor,
                              size: 26,
                            ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ! driver is online 
  Future<void> driverIsOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition();
    driverCurrentPositioned = position;
    Geofire.initialize("activeDrivers");

    Geofire.setLocation(
      currentFirebaseUser!.uid,
      driverCurrentPositioned!.latitude,
      driverCurrentPositioned!.longitude,
    );
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    databaseReference.set("idle"); // searching for ride request
    databaseReference.ref.onValue.listen((event) {});
  }

  // ! changedriverlocation 
  Future<void> changeDriverLiveLocation() async {
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPositioned = position;
      if (isDriverActive == true) {
        Geofire.setLocation(
            currentFirebaseUser!.uid,
            driverCurrentPositioned!.latitude,
            driverCurrentPositioned!.longitude);
      }

      LatLng latlng = LatLng(driverCurrentPositioned!.latitude,
          driverCurrentPositioned!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latlng));
    });
  }

  // ! isDriverOffline
  Future<void> isDriverOffline() async {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? databaseReference = FirebaseDatabase.instance
        .ref("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    databaseReference.onDisconnect();
    databaseReference.remove();
    databaseReference = null;
    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }
}