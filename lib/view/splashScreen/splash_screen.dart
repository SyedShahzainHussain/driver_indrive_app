import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_clone_app/assistant/asistant_method.dart';

// ! file import
import 'package:uber_clone_app/extension/screenWidthHeight/mediaquery.dart';
import 'package:uber_clone_app/resources/app_colors.dart';

// ! package
import 'package:gap/gap.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    
    firebaseAuth.currentUser != null
        ? AsistantMethod.readCurrentOnlineUserInfo(context)
        : null;

    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        currentFirebaseUser = firebaseAuth.currentUser;
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.mainScreen, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.logInScreen, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.blackColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                "assets/image/logo1.png",
                width: context.screenWidth * .6,
              ),
              const Gap(10),
              Text("Uber & inDriver Clone App",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      )),
              const Spacer(),
              const SpinKitCircle(
                size: 20,
                color: AppColors.whiteColor,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
