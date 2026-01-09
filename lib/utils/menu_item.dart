import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final int? position;
  final int? index;
  const MenuItem({Key? key, this.icon, this.title, this.position, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: position == index ? Colors.red[900] : Colors.grey),
        const SizedBox(
          height: 4,
        ),
        Text(
          "$title",
          style: TextStyle(
              fontSize: 10,
              color: position == index ? Colors.red[900] : Colors.grey),
        ),
      ],
    );
  }
}
