import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone_app/assistant/asistant_method.dart';
import 'package:uber_clone_app/assistant/black_theme_google_map.dart';
import 'package:uber_clone_app/extension/screenWidthHeight/mediaquery.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/view/push_notification/push_notification.dart';

class HomeTapPage extends StatefulWidget {
  const HomeTapPage({super.key});

  @override
  State<HomeTapPage> createState() => _HomeTapPageState();
}

class _HomeTapPageState extends State<HomeTapPage> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? newGoogleMapController;
  LocationPermission? _locationPermission;

  String? statusText = "Now Offline";
  Color statusColor = Colors.grey;
  bool isDriverActive = false;
  Set<Marker> markers = Set<Marker>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15.4746,
  );

  BitmapDescriptor? iconAnimatedMarker;
  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowes();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    createDriverImage();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationEnabled: true,
              markers: markers,
              onMapCreated: (GoogleMapController googleMapController) {
                _googleMapController.complete(googleMapController);
                newGoogleMapController = googleMapController;
                blackThemeGoogleMap(newGoogleMapController);
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

  // ! read information from notification
  
  void readCurrentDriverInformation() async {
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.generateToken();
    pushNotificationSystem.iitilazeCloudMessaging(context);
  }

  // ! check  drive location permission if success then get the drive current location
  void checkIfLocationPermissionAllowes() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    } else {
      locateUserPositioned();
    }
  }
  // ! drivers current location

  void locateUserPositioned() async {
    Position cPosition = await Geolocator.getCurrentPosition();
    driverCurrentPositioned = cPosition;

    markers.removeWhere((element) => element.markerId.value == "usercurrent");
    markers.add(
      Marker(
        markerId: const MarkerId("usercurrent"),
        position: LatLng(
          driverCurrentPositioned!.latitude,
          driverCurrentPositioned!.longitude,
        ),
        icon: iconAnimatedMarker!,
      ),
    );
    setState(() {});

    await FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        onlineDrivers.id = (value.snapshot.value as Map)['id'];
        onlineDrivers.email = (value.snapshot.value as Map)['email'];
        onlineDrivers.name = (value.snapshot.value as Map)['name'];
        onlineDrivers.phone = (value.snapshot.value as Map)['phone'];
        onlineDrivers.car_color =
            (value.snapshot.value as Map)['car_details']['car_color'];
        onlineDrivers.car_model =
            (value.snapshot.value as Map)['car_details']['car_model'];
        onlineDrivers.car_number =
            (value.snapshot.value as Map)['car_details']['car_number'];
      }
    });

    LatLng latLngPositioned = LatLng(
      driverCurrentPositioned!.latitude,
      driverCurrentPositioned!.longitude,
    );

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLngPositioned, zoom: 16)));
    // ignore: use_build_context_synchronously
    await AsistantMethod.searchAddressFromLangitudeandLatitude(
        driverCurrentPositioned!, context);
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
      markers.removeWhere((element) => element.markerId.value == "usercurrent");
      markers.add(
        Marker(
          markerId: const MarkerId("usercurrent"),
          position: LatLng(
            driverCurrentPositioned!.latitude,
            driverCurrentPositioned!.longitude,
          ),
          icon: iconAnimatedMarker!
        ),
      );
      setState(() {});
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

  // ! change driver icon
  createDriverImage() async {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));

      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/image/car.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

}
