import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:uber_clone_app/extension/screenWidthHeight/mediaquery.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/widget/progress_dialog.dart';
import 'package:uber_clone_app/widget/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  ValueNotifier<bool> obsecure = ValueNotifier<bool>(false);

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is Required!");
    } else {
      saveDriverNow();
    }
  }

  void saveDriverNow() async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        message: "Processing. Please wait..",
      ),
    );
    final User? firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            // ignore: body_might_complete_normally_catch_error
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: ${msg.toString()}");
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");

      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.splashScreen, (route) => false);
        } else {
          Fluttertoast.showToast(msg: "No record exist with this email");
          firebaseAuth.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.splashScreen, (route) => false);
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occured during Login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Gap(10),
            Image.asset(
              "assets/image/logo1.png",
              width: context.screenWidth * .6,
            ),
            const Gap(10),
            Text(
              "Login as a Driver",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(10),
            TextInputField(
              controller: emailTextEditingController,
              labelText: "Email",
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const Gap(10),
            ValueListenableBuilder(
              valueListenable: obsecure,
              builder: (context, value, child) => TextField(
                obscureText: obsecure.value,
                controller: passwordTextEditingController,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: AppColors.greyColor,
                    ),
                cursorColor: AppColors.whiteColor,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          obsecure.value = !obsecure.value;
                        },
                        icon: Icon(obsecure.value
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    labelText: "Password",
                    hintText: "Password",
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: AppColors.greyColor,
                    )),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: AppColors.greyColor,
                    )),
                    hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.greyColor,
                        ),
                    labelStyle:
                        Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: AppColors.greyColor,
                            )),
              ),
            ),
            const Gap(20),
            ElevatedButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                onPressed: () {
                  validateForm();
                },
                child: Text(
                  "Login",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                )),
            const Gap(10),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteNames.signupScreen, (route) => false);
              },
              child: Text(
                "Do not have an Account? SignUp Here",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: AppColors.greyColor,
                    ),
              ),
            )
          ]),
        ),
      )),
    );
  }
}
