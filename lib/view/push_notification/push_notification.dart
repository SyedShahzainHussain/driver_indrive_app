import "package:firebase_database/firebase_database.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:uber_clone_app/view/global/global.dart";

class PushNotificationSystem {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future iitilazeCloudMessaging() async {
    // ! 1. terminate

    // * when the app is terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // * when app terminate
      if (message != null) {}
    });

    // ! 2. foreground

    // * when the app is foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {});

    // ! 3. background

    // * when the app is background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {});
  }

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
