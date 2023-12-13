import 'package:flutter/material.dart';

class RatingtabPage extends StatefulWidget {
  const RatingtabPage({super.key});

  @override
  State<RatingtabPage> createState() => _RatingtabPageState();
}

class _RatingtabPageState extends State<RatingtabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Rating")),
    );
  }
}
