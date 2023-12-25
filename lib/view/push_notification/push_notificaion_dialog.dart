import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:uber_clone_app/assistant/asistant_method.dart';
import 'package:uber_clone_app/model/user_rider_request_model.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/global/global.dart';

class PushNotificationDialog extends StatefulWidget {
  final UserRideRequestModel? userRideRequestModel;
  const PushNotificationDialog({super.key, this.userRideRequestModel});

  @override
  State<PushNotificationDialog> createState() => _PushNotificationDialogState();
}

class _PushNotificationDialogState extends State<PushNotificationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[800],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(
            "assets/image/car_logo.png",
            width: 160,
          ),
          const Gap(2),
          Text(
            "New Ride Request",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
          ),
          const Gap(20),
          const Divider(
            height: 2,
            thickness: 3,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
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
              ],
            ),
          ),
          const Divider(height: 2, thickness: 3, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    assetAudioPlayer!.pause();
                    assetAudioPlayer!.stop();
                    assetAudioPlayer = AssetsAudioPlayer();
                    FirebaseDatabase.instance
                        .ref()
                        .child("All Ride Request")
                        .child(widget.userRideRequestModel!.riderRequestId!)
                        .remove()
                        .then((value) {
                      FirebaseDatabase.instance
                          .ref()
                          .child("drivers")
                          .child(currentFirebaseUser!.uid)
                          .child("newRideStatus")
                          .set("idle")
                          .then((value) {
                        FirebaseDatabase.instance
                            .ref()
                            .child("drivers")
                            .child(currentFirebaseUser!.uid)
                            .child("tripHistory")
                            .child(widget.userRideRequestModel!.riderRequestId!)
                            .remove();
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg:
                                "Ride Request has been Cancelled, Succesfully. Restart App");
                      });
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      SystemNavigator.pop();
                    });
                  },
                  child: Text(
                    "Cancel".toUpperCase(),
                    style: const TextStyle(color: AppColors.whiteColor),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    assetAudioPlayer!.pause();
                    assetAudioPlayer!.stop();
                    assetAudioPlayer = AssetsAudioPlayer();
                    acceptRideRequest(context);
                  },
                  child: Text(
                    "Accept".toUpperCase(),
                    style: const TextStyle(color: AppColors.whiteColor),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  // ! accept the ride reqest

  acceptRideRequest(context) {
    String getRideRequest = "";
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        getRideRequest = value.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "This ride request do not exists");
      }
      if (getRideRequest == widget.userRideRequestModel!.riderRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("newRideStatus")
            .set("accepted");

        AsistantMethod.pauseLiveLocation();
        Navigator.pushNamed(context, RouteNames.newTripScreen,
            arguments: widget.userRideRequestModel);
      } else {
        Fluttertoast.showToast(msg: "This ride request do not exists");
      }
    });
  }
}
