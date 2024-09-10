import 'package:flutter/material.dart';

class CirclePainterV2 extends CustomPainter {
  double? topMargin;
  double? Function(Size size)? circleRadius;

  double progress = 0.0;

  // style
  double strokeWidth = 2.0;

  Color strokeColor = Colors.white;
  Color? overlayColor;
  Color progressColor = Colors.green;

  CirclePainterV2({
    this.topMargin,
    this.circleRadius,
    this.progress = 0.0,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.white,
    this.overlayColor,
    this.progressColor = Colors.green,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

    final overlayColor = this.overlayColor ?? Colors.black.withOpacity(0.7);
    final overlayPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = overlayColor;

    canvas.drawPath(overlayPath, overlayPaint);

    // Step 2: Draw the white stroke around the circle
    final strokePath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          size.width / 2, // x-axis center
          topMargin, // y-axis center with margin
        ),
        radius: circleRadius,
      ));

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor; // white stroke

    canvas.drawPath(strokePath, strokePaint);

    if (progress != 0.0) {
      assert(this.progress >= 0.0 && this.progress <= 1.0);
      // Step 3: Draw the progress arc (quarter circle)
      final progressRect = Rect.fromCircle(
        center: Offset(
          size.width / 2, // x-axis center
          topMargin, // y-axis center with margin
        ),
        radius: circleRadius,
      );

      final strokeProgressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = progressColor;

      final progress = this.progress * 4; // 4 means full of circle, 2 means half of circle, 1 means quarter of circle
      // Draw only a portion of the circle, progress defines how much
      canvas.drawArc(
        progressRect,
        -90 * 3.1416 / 180, // Start angle (-90° = top of the circle)
        progress * (3.14 / 2), // Sweep angle based on progress (quarter of circle = π/2 radians)
        false,
        strokeProgressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
