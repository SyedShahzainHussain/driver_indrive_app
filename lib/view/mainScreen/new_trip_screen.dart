import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_app/assistant/asistant_method.dart';
import 'package:uber_clone_app/assistant/black_theme_google_map.dart';
import 'package:uber_clone_app/model/user_rider_request_model.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/widget/fare_amount_collection_dialog.dart';
import 'package:uber_clone_app/widget/progress_dialog.dart';

class NewTripScreen extends StatefulWidget {
  final UserRideRequestModel? userRideRequestModel;
  const NewTripScreen({super.key, this.userRideRequestModel});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? newGoogleMapController;
  Set<Marker> setOfMarker = <Marker>{};
  Set<Circle> setOfCircle = <Circle>{};
  Set<Polyline> setOfPolyline = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Position? driverLiveCurrentPositioned;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  String buttonTitle = "Arrived";
  Color buttonColor = Colors.green;

  String rideRequestStatus = "accepted";
  String durationFromToOriginToDestinations = "";

  bool isRequestDirectionDetails = false;

  BitmapDescriptor? iconAnimatedMarker;
  var geoLocater = Geolocator();

  @override
  void initState() {
    super.initState();
    saveAssignedDriver();
  }

  @override
  Widget build(BuildContext context) {
    createDriverImage();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * .4),
              markers: setOfMarker,
              circles: setOfCircle,
              polylines: setOfPolyline,
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController googleMapController) {
                _googleMapController.complete(googleMapController);
                newGoogleMapController = googleMapController;
                blackThemeGoogleMap(newGoogleMapController);
                drawPolyline(
                  LatLng(driverCurrentPositioned!.latitude,
                      driverCurrentPositioned!.longitude),
                  LatLng(
                    widget.userRideRequestModel!.originLat!.latitude,
                    widget.userRideRequestModel!.originLat!.longitude,
                  ),
                );
                getDriverLiveLocation();
              },
            ),

            // ! ui

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: MediaQuery.sizeOf(context).height * .4,
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white30,
                        blurRadius: 18,
                        spreadRadius: 0.5,
                        offset: Offset(0.6, 0.6),
                      )
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        durationFromToOriginToDestinations,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                      const Gap(18),
                      const Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.grey,
                        indent: 5.0,
                        endIndent: 5.0,
                      ),
                      const Gap(18),
                      Row(
                        children: [
                          Text(
                            widget.userRideRequestModel!.username!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.phone_android,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const Gap(18),
                      Row(
                        children: [
                          Image.asset(
                            "assets/image/origin.png",
                            width: 16,
                            height: 16,
                          ),
                          const Gap(22),
                          Expanded(
                              child: Text(
                            widget.userRideRequestModel!.originAddress!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          )),
                        ],
                      ),
                      const Gap(20),
                      Row(
                        children: [
                          Image.asset(
                            "assets/image/destination.png",
                            width: 16,
                            height: 16,
                          ),
                          const Gap(22),
                          Expanded(
                              child: Text(
                            widget.userRideRequestModel!.destinationAddress!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          ))
                        ],
                      ),
                      const Gap(18),
                      const Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.grey,
                        indent: 5.0,
                        endIndent: 5.0,
                      ),
                      const Gap(24.0),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
                          onPressed: () async {
                            // * when driver accepted the request and  when driver arrived  to user current location
                            if (rideRequestStatus == "accepted") {
                              rideRequestStatus = "arrived";

                              FirebaseDatabase.instance
                                  .ref()
                                  .child("All Ride Request")
                                  .child(widget
                                      .userRideRequestModel!.riderRequestId!)
                                  .child("status")
                                  .set(rideRequestStatus);

                              setState(() {
                                buttonTitle = "Let's Go";
                                buttonColor = Colors.lightGreen;
                              });

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => ProgressDialog(
                                        message: "Loading...",
                                      ));
                              await drawPolyline(
                                widget.userRideRequestModel!.originLat!,
                                widget.userRideRequestModel!.destinationLat!,
                              );
                              Navigator.pop(context);
                            }
                            // * when user has already sit in driver car . Driver start the trip
                            else if (rideRequestStatus == "arrived") {
                              rideRequestStatus = "onTrip";

                              FirebaseDatabase.instance
                                  .ref()
                                  .child("All Ride Request")
                                  .child(widget
                                      .userRideRequestModel!.riderRequestId!)
                                  .child("status")
                                  .set(rideRequestStatus);

                              setState(() {
                                buttonTitle = "End Trip";
                                buttonColor = Colors.redAccent;
                              });
                            } else if (rideRequestStatus == "onTrip") {
                              endTrip();
                            }
                          },
                          icon: const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 25,
                          ),
                          label: Text(
                            buttonTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ! end trip
  endTrip() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        message: "Waiting...",
      ),
    );

    // var currentDriverPositionLatLng = LatLng(
    //   driverLiveCurrentPositioned!.latitude,
    //   driverLiveCurrentPositioned!.longitude,
    // );

// * checking if the user reach to the destination and then check the driver current location with user pickup location
    var tripDirectionDetails =
        await AsistantMethod.obtainedOriginToDestinationDirectionDetails(
      widget.userRideRequestModel!.originLat!,
      widget.userRideRequestModel!.destinationLat!,
    );

    double totalFareAmount =
        AsistantMethod.calculateFareAmount(tripDirectionDetails!);

    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestModel!.riderRequestId!)
        .child("fareAmount")
        .set(totalFareAmount.toString());
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(widget.userRideRequestModel!.riderRequestId!)
        .child("status")
        .set("ended");
    streamLiveDriversSubscription!.cancel();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) =>
          FareAmountCollectionDialog(totalfare: totalFareAmount),
    );

    saveFareAmountToDriverEarnings(totalFareAmount);
  }

  // ! save the fare to the drivers earning
  saveFareAmountToDriverEarnings(totalFareAmount) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("earning")
        .once()
        .then((value) {
      // * if earning is already ther im updating the earning
      if (value.snapshot.value != null) {
        var oldtotalAMount = double.parse(value.snapshot.value.toString());
        var totalAmount = totalFareAmount + oldtotalAMount;
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("earning")
            .set(totalAmount);
      } else {
        // * else add a new earning
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("earning")
            .set(totalFareAmount.toString());
      }
    });
  }

  // ! gettimeatrealtime

  updateDurationTimeAtRealTime() async {
    if (isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;
      if (driverLiveCurrentPositioned == null) {
        return;
      }
      var originLatlng = LatLng(
        driverLiveCurrentPositioned!.latitude,
        driverLiveCurrentPositioned!.longitude,
      );
      LatLng? destinationLatlng;
      if (rideRequestStatus == "accepted") {
        destinationLatlng =
            widget.userRideRequestModel!.originLat; // User Pick Up Location
      } else {
        destinationLatlng = widget
            .userRideRequestModel!.destinationLat; // User drop Of Location
      }
      var destination =
          await AsistantMethod.obtainedOriginToDestinationDirectionDetails(
        originLatlng,
        destinationLatlng!,
      );

      if (destination != null) {
        setState(() {
          durationFromToOriginToDestinations = destination.duration_text!;
        });
      }
      isRequestDirectionDetails = false;
    }
  }

  // ! draw Polyline

  // * step 1 : first driver current position and user pickup position
  // * step 2 : second driver current or user pickup position and user dropoff position

  Future<void> drawPolyline(
    LatLng originLatLng,
    LatLng destinationLatLng,
  ) async {
    var originlatLng = LatLng(originLatLng.latitude, originLatLng.longitude);
    var destinationlatLng =
        LatLng(destinationLatLng.latitude, destinationLatLng.longitude);
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(
              message: "Please wait...",
            ));

    var directionDetailInfo =
        await AsistantMethod.obtainedOriginToDestinationDirectionDetails(
      originLatLng,
      destinationLatLng,
    );

    Navigator.pop(context);
    List<PointLatLng> decodePpointsResult =
        polylinePoints.decodePolyline(directionDetailInfo!.e_points!);
    polylineCoordinates.clear();
    if (decodePpointsResult.isNotEmpty) {
      for (var position in decodePpointsResult) {
        polylineCoordinates.add(LatLng(position.latitude, position.longitude));
      }
    }

    // * polyline

    setOfPolyline.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId("PolylineId"),
        points: polylineCoordinates,
        color: const Color(0xff7fbefb),
        geodesic: true,
        jointType: JointType.round,
        width: 2,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
      );
      setOfPolyline.add(polyline);
    });

    // * marker
    Marker originMarker = Marker(
        markerId: const MarkerId("originMarker"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: originlatLng,
        infoWindow: const InfoWindow(title: "originMarker"));

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationMarker"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: destinationLatLng,
      infoWindow: const InfoWindow(title: "destinationMarker"),
    );

    setState(() {
      setOfMarker.add(originMarker);
      setOfMarker.add(destinationMarker);
    });

    // * circle

    Circle orginCircle = Circle(
      circleId: const CircleId("originCircle"),
      center: originLatLng,
      radius: 18,
      strokeWidth: 2,
      strokeColor: AppColors.whiteColor,
      fillColor: Colors.green,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationCircle"),
      center: destinationLatLng,
      radius: 18,
      strokeWidth: 2,
      strokeColor: AppColors.whiteColor,
      fillColor: Colors.blue,
    );

    setState(() {
      setOfCircle.add(orginCircle);
      setOfCircle.add(destinationCircle);
    });

    // * latlngbounds

    LatLngBounds latLngBounds;

    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: destinationlatLng,
        northeast: originlatLng,
      );
    } else if (originLatLng.latitude > destinationlatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(destinationlatLng.latitude, originlatLng.longitude),
        northeast: LatLng(originlatLng.latitude, destinationlatLng.longitude),
      );
    } else if (originlatLng.longitude > destinationlatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(originlatLng.latitude, destinationlatLng.longitude),
        northeast: LatLng(destinationlatLng.latitude, originlatLng.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(
        southwest: originlatLng,
        northeast: destinationlatLng,
      );
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  // ! saveAssign

  saveAssignedDriver() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("All Ride Request").child(
              widget.userRideRequestModel!.riderRequestId!,
            );

    Map driverLocationMap = {
      "latitude": driverCurrentPositioned!.latitude,
      "longitude": driverCurrentPositioned!.longitude,
    };
    databaseReference.child("driverLocation").set(driverLocationMap);

    databaseReference.child("status").set("accepted");

    databaseReference.child("driverId").set(onlineDrivers.id);
    databaseReference.child("driverName").set(onlineDrivers.name);
    databaseReference.child("driverPhone").set(onlineDrivers.phone);
    databaseReference.child("car_details").set(
          "${onlineDrivers.car_color}  ${onlineDrivers.car_model}  ${onlineDrivers.car_number}",
        );

    saveRideRequestIdToDriverHistory();
  }

  // ! saveRideRequestHistory
  saveRideRequestIdToDriverHistory() {
    DatabaseReference tripHistory = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("tripHistory");

    tripHistory.child(widget.userRideRequestModel!.riderRequestId!).set(true);
  }

  // ! create image for map

  createDriverImage() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: const Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        "assets/image/car.png",
      ).then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  // ! get driverslivelocation

  getDriverLiveLocation() {
    var oldLatLng = const LatLng(0, 0);
    streamLiveDriversSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPositioned = position;
      driverLiveCurrentPositioned = position;

      LatLng latLng = LatLng(driverLiveCurrentPositioned!.latitude,
          driverLiveCurrentPositioned!.longitude);

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLng,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your positioned"),
      );

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLng, zoom: 14);
        newGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setOfMarker.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarker.add(animatingMarker);
      });
      oldLatLng = latLng;
      updateDurationTimeAtRealTime();

      // * update the drive location
      Map driverLatLng = {
        "latitude": driverLiveCurrentPositioned!.latitude,
        "longitude": driverLiveCurrentPositioned!.longitude,
      };
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(widget.userRideRequestModel!.riderRequestId!)
          .child("driverLocation")
          .set(driverLatLng);
    });
  }
}
