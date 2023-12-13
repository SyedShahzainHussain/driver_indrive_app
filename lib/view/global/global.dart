import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone_app/model/user_model.dart';

const mapKey = "AIzaSyAoSbver7G9emTgsZMM4RCAXt3z5pjauYE";
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
DriversModel? userModel;
StreamSubscription<Position>? streamSubscription;
