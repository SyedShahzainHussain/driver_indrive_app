import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone_app/model/online_drivers.dart';
import 'package:uber_clone_app/model/user_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

const mapKey = "AIzaSyAoSbver7G9emTgsZMM4RCAXt3z5pjauYE";
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
DriversModel? userModel;
StreamSubscription<Position>? streamSubscription;
StreamSubscription<Position>? streamLiveDriversSubscription;
AssetsAudioPlayer? assetAudioPlayer = AssetsAudioPlayer();
Position? driverCurrentPositioned;
String? driverVehicleType = "";

OnlineDrivers onlineDrivers = OnlineDrivers();
