import 'package:flutter/material.dart';

import 'custom_shimmer.dart';

class ProShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  const ProShimmer(
      {Key? key, required this.height, required this.width, this.radius = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomShimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(radius)),
        ),
      ),
    );
  }
}
