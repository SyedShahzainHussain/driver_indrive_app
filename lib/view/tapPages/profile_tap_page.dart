import 'package:flutter/material.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/global/global.dart';

class ProfileTapPage extends StatefulWidget {
  const ProfileTapPage({super.key});

  @override
  State<ProfileTapPage> createState() => _ProfileTapPageState();
}

class _ProfileTapPageState extends State<ProfileTapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          firebaseAuth.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.splashScreen, (route) => false);
        },
        child: const Text("Sign out"),
      )),
    );
  }
}
