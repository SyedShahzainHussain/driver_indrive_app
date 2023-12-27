import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/resources/routes/routes_name.dart';
import 'package:uber_clone_app/view/provider/app_info.dart';

class EarningTapPage extends StatefulWidget {
  const EarningTapPage({super.key});

  @override
  State<EarningTapPage> createState() => _EarningTapPageState();
}

class _EarningTapPageState extends State<EarningTapPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          // * earnings
          Container(
            color: Colors.black,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(children: [
                Text("Your Earnings",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.grey,
                        )),
                const Gap(10),
                Text("\$ ${context.read<AppInfo>().totalEarning}",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const Gap(10),
          // total number of trips
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white54),
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.newTripHistory);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/image/car_logo.png",
                      width: 100,
                    ),
                    const Gap(20),
                    const Text(
                      "Total Trips Completed",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        context.read<AppInfo>().tripHistory.length.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
