import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/view/provider/app_info.dart';
import 'package:uber_clone_app/widget/trip_history_design.dart';


class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title:
            const Text("Trips History", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.black,
            thickness: 2,
            height: 2,
          );
        },
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white54,
            child: TripHistoryDesign(
              tripHistoryModel: context.read<AppInfo>().tripHistory[index],
            ),
          );
        },
        itemCount: context.read<AppInfo>().tripHistory.length,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}
