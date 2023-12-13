import 'package:flutter/material.dart';

class EarningTapPage extends StatefulWidget {
  const EarningTapPage({super.key});

  @override
  State<EarningTapPage> createState() => _EarningTapPageState();
}

class _EarningTapPageState extends State<EarningTapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Earning")),
    );
  }
}
