import 'package:flutter/material.dart';

class CirclePainterV2 extends CustomPainter {
  double? topMargin;
  double? Function(Size size)? circleRadius;

  CirclePainterV2({
    this.circleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // // Step 1: Draw the overlay with transparent circle
    // final overlayPath = Path()
    //   ..addOval(Rect.fromCircle(
    //     center: Offset(
    //       size.width / 2, // x-axis center
    //       (size.height * 0.1), // y-axis center with margin
    //     ),
    //     radius: (size.width / 1.25) / 2, // circle radius
    //   ))
    //   ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
    //   ..fillType = PathFillType.evenOdd;
    //
    // final overlayPaint = Paint()
    //   ..style = PaintingStyle.fill
    //   ..color = Colors.black.withOpacity(0.5); // semi-transparent black overlay
    //
    // canvas.drawPath(overlayPath, overlayPaint);
    //
    // // Step 2: Draw the white stroke around the circle
    // final strokePath = Path()
    //   ..addOval(Rect.fromCircle(
    //     center: Offset(
    //       size.width / 2, // x-axis center
    //       (size.height * 0.1), // y-axis center with margin
    //     ),
    //     radius: (size.width / 1.25) / 2, // same radius as the transparent circle
    //   ));
    //
    // final strokePaint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 5
    //   ..color = Colors.white; // white stroke
    //
    // canvas.drawPath(strokePath, strokePaint);

    final circleRadius = this.circleRadius?.call(size) ?? ((size.width / 1.25) / 2);
    final topMargin = this.topMargin ?? (size.height * 0.35);

    // Step 1: Draw the overlay with transparent circle
    final overlayPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(
            size.width / 2, // x-axis center
            topMargin, // y-axis center with margin
          ),
          radius: circleRadius,
        ),
      )
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;

    final overlayPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.5); // semi-transparent black overlay

    canvas.drawPath(overlayPath, overlayPaint);

    // Step 2: Draw the white stroke around the circle
    final strokePath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          size.width / 2, // x-axis center
          topMargin, // y-axis center with margin
        ),
        radius: circleRadius, // same radius as the transparent circle
      ));

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.white; // white stroke

    canvas.drawPath(strokePath, strokePaint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
