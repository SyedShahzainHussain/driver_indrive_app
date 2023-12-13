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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  ValueNotifier<bool> obsecure = ValueNotifier<bool>(false);

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    } else {
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Processing. Please wait..",
      ),
    );
    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(
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
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        RouteNames.carInfoScreen,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
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
          child: Column(
            children: [
              const Gap(10),
              Image.asset(
                "assets/image/logo1.png",
                width: context.screenWidth * .6,
              ),
              const Gap(10),
              Text(
                "Register as a Driver",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(10),
              TextInputField(
                controller: nameTextEditingController,
                labelText: "Name",
                hintText: "Name",
              ),
              const Gap(10),
              TextInputField(
                controller: emailTextEditingController,
                labelText: "Email",
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(10),
              TextInputField(
                  controller: phoneTextEditingController,
                  labelText: "Phone",
                  hintText: "Phone",
                  keyboardType: TextInputType.phone),
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
                      hintStyle:
                          Theme.of(context).textTheme.labelSmall!.copyWith(
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
                    "Create Account",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                  )),
              const Gap(10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteNames.logInScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.greyColor,
                      ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
