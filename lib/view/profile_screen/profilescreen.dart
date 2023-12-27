import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/view/provider/user_provider.dart';
import 'package:uber_clone_app/widget/info_design_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final data = context.read<UserProvider>();
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // * name
            Text(
              data.user!.name!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              titleRating,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                thickness: 2,
                height: 2,
              ),
            ),
            const Gap(38),
            // * phone
            DesignInfoWidget(
              title: data.user!.phone!,
              iconData: Icons.phone_iphone,
            ),

            // * email
            DesignInfoWidget(
              title: data.user!.email!,
              iconData: Icons.email,
            ),
            // * car details
            DesignInfoWidget(
              title:
                  "${onlineDrivers.car_color!} ${onlineDrivers.car_model!} ${onlineDrivers.car_number!}",
              iconData: Icons.email,
            ),
            const Gap(10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  SystemNavigator.pop();
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        )));
  }
}
