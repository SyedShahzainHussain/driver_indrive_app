import 'package:flutter/material.dart';

class DesignInfoWidget extends StatefulWidget {
  final String? title;
  final IconData? iconData;
  const DesignInfoWidget({super.key, this.title, this.iconData});

  @override
  State<DesignInfoWidget> createState() => _DesignInfoWidgetState();
}

class _DesignInfoWidgetState extends State<DesignInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        title: Text(widget.title!,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
      ),
    );
  }
}
