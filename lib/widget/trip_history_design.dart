import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_clone_app/model/trip_history_model.dart';
import 'package:intl/intl.dart';

class TripHistoryDesign extends StatefulWidget {
  final TripHistoryModel? tripHistoryModel;
  const TripHistoryDesign({super.key, this.tripHistoryModel});

  @override
  State<TripHistoryDesign> createState() => _TripHistoryDesignState();
}

class _TripHistoryDesignState extends State<TripHistoryDesign> {
  String formattedAddress(String dateTime) {
    DateTime datetime = DateTime.parse(dateTime);
    // Dec 10                             // 2024                             // 1:12
    String formattedAddress =
        "${DateFormat.MMMd().format(datetime)},${DateFormat.y().format(datetime)},${DateFormat.jm().format(datetime)}";

    return formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * driver name + fare amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(widget.tripHistoryModel!.username!,style: const TextStyle(color:Colors.white,)),
                  ),
                  const Gap(12),
                  Text(
                    "\$${widget.tripHistoryModel!.fareAmount!}",
                    style: const TextStyle(
                      fontSize: 20,
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Gap(2),

              // * car details
              Row(
                children: [
                  const Icon(
                    Icons.car_repair,
                    color: Colors.black,
                  ),
                  const Gap(12),
                  Text(widget.tripHistoryModel!.carDetails!,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.grey)),
                ],
              ),

              const Gap(20),
              // * icon + pickUp
              Row(
                children: [
                  Image.asset("assets/image/origin.png",
                      width: 30, height: 30),
                  const Gap(12),
                  Expanded(
                    child: Text(widget.tripHistoryModel!.originAddress!,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.labelSmall!.copyWith(color:Colors.white,)),
                  ),
                ],
              ),
              const Gap(14),
              // * icon + dropOff
              Row(
                children: [
                  Image.asset("assets/image/destination.png",
                      width: 30, height: 30),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      widget.tripHistoryModel!.destinationAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(color:Colors.white,),
                    ),
                  ),
                ],
              ),
              const Gap(14),
              // trip time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(""),
                  Text(
                      formattedAddress(
                        widget.tripHistoryModel!.time!,
                      ),
                      style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ));
  }
}
