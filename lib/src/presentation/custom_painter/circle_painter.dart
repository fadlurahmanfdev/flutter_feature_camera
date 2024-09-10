import 'package:flutter/material.dart';

@Deprecated('use CirclePainterV2 instead')
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          size.width / 2, // x axis in the middle of the screen
          0 + ((size.width / 1.25) / 2) + (size.height * 0.1),
        ),
        radius: (size.width / 1.25) / 2,
      ))
      ..fillType = PathFillType.evenOdd;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}