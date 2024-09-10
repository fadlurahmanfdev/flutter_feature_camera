import 'package:flutter/material.dart';

@Deprecated('use RectanglePainterV2 instead')
class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(20, 100, size.width - 20, size.height * 0.5),
          const Radius.circular(10),
        ),
      )
      ..fillType = PathFillType.evenOdd;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
