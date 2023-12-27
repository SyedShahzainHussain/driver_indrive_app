import 'package:flutter/material.dart';
import 'package:uber_clone_app/model/user_rider_request_model.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/authentication/carInfoScreen/car_info_screen.dart';
import 'package:uber_clone_app/view/authentication/loginScreen/login_screen.dart';
import 'package:uber_clone_app/view/authentication/signUpScreen/sign_up_screen.dart';
import 'package:uber_clone_app/view/mainScreen/main_screen.dart';
import 'package:uber_clone_app/view/mainScreen/new_trip_screen.dart';
import 'package:uber_clone_app/view/splashScreen/splash_screen.dart';
import 'package:uber_clone_app/view/trip_history_screen/trip_history_screen.dart';

class Routes {
  static Route<dynamic> generatesRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => const MySplashScreen());
      case RouteNames.mainScreen:
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case RouteNames.signupScreen:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case RouteNames.carInfoScreen:
        return MaterialPageRoute(builder: (context) => const CarInfoScreen());
      case RouteNames.logInScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RouteNames.newTripHistory:
        return MaterialPageRoute(
            builder: (context) => const TripHistoryScreen());
      case RouteNames.newTripScreen:
        final userRideRequestModel = settings.arguments as UserRideRequestModel;
        return MaterialPageRoute(
            builder: (context) => NewTripScreen(
                  userRideRequestModel: userRideRequestModel,
                ));
      default:
        return MaterialPageRoute(builder: (ctx) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
