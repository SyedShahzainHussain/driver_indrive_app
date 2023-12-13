import 'package:flutter/material.dart';

extension ScreenMediaQuery on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height *1;
  double get screenWidth => MediaQuery.sizeOf(this).width *1;

}
