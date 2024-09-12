import 'package:flutter/material.dart';

/// A custom painter that draws a semi-transparent overlay with a circular cutout and optional progress arc,
/// typically used as an overlay for selfie cameras to focus on the subject in the center of the screen.
///
/// The `CirclePainterV2` class is designed to paint an overlay on the screen with a clear circle in the center,
/// making it suitable for use in selfie camera applications, or any use case that requires a circular overlay.
/// Additionally, it supports drawing a progress arc around the circle, which can be useful for indicating capture progress.
///
/// ### Customization:
/// - `topMargin`: Adjust the vertical position of the circle.
/// - `circleRadius`: A callback function that determines the radius of the circle based on the screen size.
/// - `progress`: A value between 0.0 and 1.0 that controls the portion of the progress arc to be drawn around the circle.
///   For example, 0.25 represents a quarter circle, 0.5 represents half, and 1.0 represents a full circle.
/// - `strokeWidth`: Customize the thickness of the circle stroke and progress arc.
/// - `strokeColor`: Define the color of the circle's stroke (default is white).
/// - `overlayColor`: Change the color and opacity of the overlay surrounding the circle.
/// - `progressColor`: Set the color of the progress arc (default is green).
///
/// ### Usage Example:
///
/// Here's how you can use the `CirclePainterV2` in a camera preview setup, typically for selfies:
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(
///       title: const Text("Camera Selfie Page", style: TextStyle(color: Colors.black)),
///     ),
///     body: Stack(
///       children: [
///         // Camera preview area
///         Container(
///           alignment: Alignment.center,
///           child: cameraController?.value.isInitialized == true
///               ? CameraPreview(cameraController!)
///               : Container(),
///         ),
///         // Circular overlay for selfie capture
///         IgnorePointer(
///           child: CustomPaint(
///             painter: CirclePainterV2(
///               progress: 0.5, // Draw half of the progress arc (optional)
///             ),
///             child: Container(),
///           ),
///         ),
///       ],
///     ),
///   );
/// }
/// ```
///
/// This painter is useful for creating a focused circular overlay for selfie or face-related captures,
/// and the progress arc can be used for visual feedback during actions like countdowns or photo captures.
///
/// For more detailed examples, refer to the [example](https://github.com/fadlurahmanfdev/flutter_feature_camera/blob/master/example/lib/presentation/camera_selfie_page_v2.dart).
///
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
