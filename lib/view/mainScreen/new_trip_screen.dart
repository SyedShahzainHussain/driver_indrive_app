import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_app/assistant/black_theme_google_map.dart';
import 'package:uber_clone_app/model/user_rider_request_model.dart';

class NewTripScreen extends StatefulWidget {
  final UserRideRequestModel? userRideRequestModel;
  const NewTripScreen({super.key, this.userRideRequestModel});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String buttonTitle = "Arrived";
  Color buttonColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController googleMapController) {
              _googleMapController.complete(googleMapController);
              newGoogleMapController = googleMapController;
              blackThemeGoogleMap(newGoogleMapController);
            },
          ),

          // ! ui
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
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
              child: Column(
                children: [
                  const Text(
                    "18 mins",
                    style: TextStyle(
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
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
                      onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
