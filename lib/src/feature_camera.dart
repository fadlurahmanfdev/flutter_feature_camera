import 'dart:typed_data';
import 'package:image/image.dart' as image_lib;

class FeatureCamera {
  static double? calculateBrightness(Uint8List imageBytes) {
    image_lib.Image? image = image_lib.decodeImage(imageBytes);
    if (image == null) return null;

    int width = image.width;
    int height = image.height;
    int brightnessSum = 0;
    int pixelCount = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        // Calculate luminance (perceived brightness)
        double luminance = (0.299 * r + 0.587 * g + 0.114 * b);
        brightnessSum += luminance.toInt();
        pixelCount++;
      }
    }
    final averageBrightness = brightnessSum / pixelCount;
    return averageBrightness / 255.0;
  }
}
