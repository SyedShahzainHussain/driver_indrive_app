import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:uber_clone_app/extension/screenWidthHeight/mediaquery.dart';
import 'package:uber_clone_app/resources/app_colors.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/widget/text_input_field.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextController = TextEditingController();
  TextEditingController carNumberTextController = TextEditingController();
  TextEditingController carColorTextController = TextEditingController();

  List<String> carTypesLise = ["uber-x", "uber-go", "bikes"];
  String? selectedCarType;

  saveCarInfo() {
    Map driverCarInfoMap = {
      "car_color": carColorTextController.text.trim(),
      "car_number": carNumberTextController.text.trim(),
      "car_model": carModelTextController.text.trim(),
      "type": selectedCarType
    };
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");
    driversRef
        .child(currentFirebaseUser!.uid)
        .child("car_details")
        .set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car Details has been saved, Congratulations");
    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.splashScreen, (route) => false);
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
                  "Write Car Details",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(10),
                TextInputField(
                  controller: carModelTextController,
                  labelText: "Car Model",
                  hintText: "Car Model",
                ),
                const Gap(10),
                TextInputField(
                  controller: carNumberTextController,
                  labelText: "Car Number",
                  hintText: "Car Number",
                ),
                const Gap(10),
                TextInputField(
                  controller: carColorTextController,
                  labelText: "Car Color",
                  hintText: "Car Color",
                ),
                const Gap(10),
                DropdownButton(
                  dropdownColor: Colors.white,
                  value: selectedCarType,
                  items: carTypesLise
                      .map(
                        (car) => DropdownMenuItem(
                          value: car,
                          child: Text(
                            car,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColors.greyColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCarType = newValue.toString();
                    });
                  },
                  hint: Text(
                    "Please choose Car Type",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.greyColor,
                        ),
                  ),
                ),
                const Gap(20),
                ElevatedButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                    onPressed: () {
                      if (carModelTextController.text.isNotEmpty &&
                          carNumberTextController.text.isNotEmpty &&
                          carColorTextController.text.isNotEmpty &&
                          selectedCarType != null) {
                        saveCarInfo();
                      }
                    },
                    child: Text(
                      "Save Now",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
