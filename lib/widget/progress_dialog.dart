import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_clone_app/resources/app_colors.dart';

// ignore: must_be_immutable
class ProgressDialog extends StatelessWidget {
  String? message;

  ProgressDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Gap(6),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const Gap(26.0),
              Expanded(
                child: Text(message!,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
