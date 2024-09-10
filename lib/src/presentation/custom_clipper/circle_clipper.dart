import 'package:flutter/material.dart';

@Deprecated('use CirclePainterV2 instead')
class CircleClipper extends CustomClipper<Path> {
  double? topMargin;

  CircleClipper({
    this.topMargin,
  });

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCenter(
        center: Offset(
          size.width / 2, // x axis in the middle of the screen
          0 + ((size.width / 1.25) / 2) + (topMargin ?? (size.height * 0.1)),
        ),
        width: size.width / 1.25,
        height: size.width / 1.25,
      ))
      ..addRect(Rect.fromLTWH(0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
