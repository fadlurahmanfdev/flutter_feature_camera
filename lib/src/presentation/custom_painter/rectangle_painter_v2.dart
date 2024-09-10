import 'dart:ui';

import 'package:flutter/material.dart';

class RectanglePainterV2 extends CustomPainter {
  double? topMargin;
  Size? Function(Size)? size;

  // style
  double strokeWidth = 2.0;
  Color strokeColor = Colors.white;
  Color? overlayColor;

  RectanglePainterV2({
    this.topMargin,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.white,
    this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final topMargin = this.topMargin ?? (size.height * 0.3);
    final width = this.size?.call(size)?.width ?? size.width * 0.8;
    final height = this.size?.call(size)?.height ?? ((size.width * 0.8) / 1.5);

    // Step 1: Draw the overlay with transparent rectangle
    final overlayPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, topMargin),
            width: width,
            height: height,
          ),
          const Radius.circular(10),
        ),
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;

    final overlayColor = this.overlayColor ?? Colors.black.withOpacity(0.7);
    final overlayPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = overlayColor; // semi-transparent black overlay

    canvas.drawPath(overlayPath, overlayPaint);

    // Step 2: Draw the white stroke around the circle
    final strokePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, topMargin),
            width: width,
            height: height,
          ),
          const Radius.circular(10),
        ),
      );

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor; // white stroke

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
