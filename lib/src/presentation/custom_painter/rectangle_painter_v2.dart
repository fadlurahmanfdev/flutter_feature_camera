import 'dart:ui';

import 'package:flutter/material.dart';

/// A custom painter that draws a semi-transparent overlay with a centered rectangular cutout,
/// typically used as a camera overlay to highlight the area for capturing ID cards or documents.
///
/// The `RectanglePainterV2` class paints an overlay on the screen with a clear rectangle in the center,
/// allowing users to focus on the content within the rectangle (e.g., for taking ID card photos).
///
/// ### Customization:
/// - `topMargin`: Adjust the vertical position of the rectangle.
/// - `size`: A callback function that takes the screen size as an input and returns a custom size for the rectangle.
///           This allows developers to dynamically control the dimensions of the rectangle based on the screen or parent widget's size.
/// - `strokeWidth`: Customize the stroke thickness around the rectangle.
/// - `strokeColor`: Define the stroke color (default is white).
/// - `overlayColor`: Change the color and opacity of the overlay surrounding the rectangle.
/// - `borderRadius`: Add rounded corners to the rectangle.
///
/// ### Usage Example:
///
/// Here's how you can use the `RectanglePainterV2` in a camera preview setup:
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(
///       title: const Text("Camera ID Card Page", style: TextStyle(color: Colors.black)),
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
///         // Overlay rectangle for ID card capture
///         IgnorePointer(
///           child: CustomPaint(
///             painter: RectanglePainterV2(),
///             child: Container(),
///           ),
///         ),
///       ],
///     ),
///   );
/// }
/// ```
///
/// For more detailed examples, refer to the [example](https://github.com/fadlurahmanfdev/flutter_feature_camera/blob/master/example/lib/presentation/camera_id_card_page_v2.dart).
///
/// This class is particularly useful in scenarios where users need guidance on framing specific regions,
/// such as ID card or document scanning.
class RectanglePainterV2 extends CustomPainter {
  double? topMargin;
  Size? Function(Size)? size;

  // style
  double strokeWidth = 2.0;
  Color strokeColor = Colors.white;
  Color? overlayColor;
  Radius? borderRadius;

  RectanglePainterV2({
    this.topMargin,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.white,
    this.overlayColor,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final topMargin = this.topMargin ?? (size.height * 0.3);
    final width = this.size?.call(size)?.width ?? size.width * 0.8;
    final height = this.size?.call(size)?.height ?? ((size.width * 0.8) / 1.5);
    final borderRadius = this.borderRadius ?? const Radius.circular(10);

    // Step 1: Draw the overlay with transparent rectangle
    final overlayPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, topMargin),
            width: width,
            height: height,
          ),
          borderRadius,
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
          borderRadius,
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
