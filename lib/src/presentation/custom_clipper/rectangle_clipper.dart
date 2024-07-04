import 'package:flutter/material.dart';

class RectangleClipper extends CustomClipper<Path> {
  double? topMargin;

  RectangleClipper({
    this.topMargin,
  });

  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(20, 100, size.width - 20, size.height * 0.5),
          const Radius.circular(10),
        ),
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
