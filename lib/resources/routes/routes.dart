import 'package:flutter/material.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/authentication/carInfoScreen/car_info_screen.dart';
import 'package:uber_clone_app/view/authentication/loginScreen/login_screen.dart';
import 'package:uber_clone_app/view/authentication/signUpScreen/sign_up_screen.dart';
import 'package:uber_clone_app/view/mainScreen/main_screen.dart';
import 'package:uber_clone_app/view/splashScreen/splash_screen.dart';

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
