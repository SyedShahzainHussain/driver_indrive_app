import "package:assets_audio_player/assets_audio_player.dart";
import "package:firebase_database/firebase_database.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:uber_clone_app/model/user_rider_request_model.dart";
import "package:uber_clone_app/view/global/global.dart";
import "package:uber_clone_app/view/push_notification/push_notificaion_dialog.dart";

class PushNotificationSystem {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  readUserRideRequest(String userRideRequest, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(userRideRequest)
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        // ! origin Address

        assetAudioPlayer!.open(Audio("music/2.1 music_notification.mp3"));
        assetAudioPlayer!.play();

        double originLat = double.parse(
            (snapshot.snapshot.value as Map)['origin']['latitude'].toString());
        double originLng = double.parse(
            (snapshot.snapshot.value as Map)["origin"]["longitude"].toString());
        String originAddress =
            (snapshot.snapshot.value as Map)["originAddress"];

        // ! pickup Address

        double destinationLat = double.parse(
            (snapshot.snapshot.value as Map)['destination']['latitude']
                .toString());
        double destinationLng = double.parse(
            (snapshot.snapshot.value as Map)["destination"]["longitude"]
                .toString());
        String destinationAddress =
            (snapshot.snapshot.value as Map)["destinationAddress"];

        // ! user information

        String username = (snapshot.snapshot.value as Map)["userName"];
        String userphone = (snapshot.snapshot.value as Map)["userPhone"];

        UserRideRequestModel userRideRequestModel = UserRideRequestModel();

        userRideRequestModel.originLat = LatLng(originLat, originLng);

        userRideRequestModel.destinationLat =
            LatLng(destinationLat, destinationLng);

        userRideRequestModel.originAddress = originAddress;
        userRideRequestModel.destinationAddress = destinationAddress;
        userRideRequestModel.username = username;
        userRideRequestModel.userphone = userphone;
        userRideRequestModel.riderRequestId = snapshot.snapshot.key;

        showDialog(
          context: context,
          builder: (BuildContext context) => PushNotificationDialog(
              userRideRequestModel: userRideRequestModel),
        );
      } else {
        return Fluttertoast.showToast(msg: "This Ride Request Id do not exist");
      }
    });
  }

  Future iitilazeCloudMessaging(BuildContext context) async {
    // ! 1. terminate

    // * when the app is terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // * when app terminate
      if (message != null) {
        readUserRideRequest(message.data["riderRequestId"], context);
      }
    });

    // ! 2. foreground

    // * when the app is foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      readUserRideRequest(message!.data["riderRequestId"], context);
    });

    // ! 3. background

    // * when the app is background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      readUserRideRequest(message!.data["riderRequestId"], context);
    });
  }

  // ! generate token

  Future<void> generateToken() async {
    String? token = await firebaseMessaging.getToken();

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(token);

    firebaseMessaging.subscribeToTopic("allDrivers");
    firebaseMessaging.subscribeToTopic("allUsers");
  }
}
