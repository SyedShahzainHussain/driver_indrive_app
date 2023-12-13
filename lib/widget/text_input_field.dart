
import 'package:flutter/material.dart';
import 'package:uber_clone_app/resources/app_colors.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: AppColors.greyColor,
          ),
      cursorColor: AppColors.whiteColor,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
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
          labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.greyColor,
              )),
    );
  }
}
