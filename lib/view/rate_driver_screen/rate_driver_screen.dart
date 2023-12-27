import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:gap/gap.dart';
import 'package:uber_clone_app/view/global/global.dart';
import 'package:uber_clone_app/view/provider/app_info.dart';

class RateDriverScreen extends StatefulWidget {
  const RateDriverScreen({
    super.key,
  });

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  double ratingNumber = 0;
 

  setUpRatingTitle() {
    if (ratingNumber == 1) {
      setState(() {
        titleRating = "Very Bad";
      });
    }
    if (ratingNumber == 2) {
      setState(() {
        titleRating = "Bad";
      });
    }
    if (ratingNumber == 3) {
      setState(() {
        titleRating = "Good";
      });
    }
    if (ratingNumber == 4) {
      setState(() {
        titleRating = "Very Good";
      });
    }
    if (ratingNumber == 5) {
      setState(() {
        titleRating = "Excellent";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRatingNumber();
  }

  getRatingNumber() {
    setState(() {
      ratingNumber = double.parse(context.read<AppInfo>().totalRating);
    });
    setUpRatingTitle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white60,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              "Your Rating:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const Gap(22),
            const Divider(
              height: 4.0,
              thickness: 4.0,
            ),
            const Gap(22.0),
            SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: ratingNumber,
                size: 40.0,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half_rounded,
                color: Colors.green,
                borderColor: Colors.green,
                spacing: 0.0),
            const Gap(12.0),
            Text(
              titleRating,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(12.0),
          ]),
        ),
      ),
    );
  }
}
