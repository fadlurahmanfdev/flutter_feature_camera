import 'dart:io';
import 'package:exif/exif.dart';

class CaptureImageModel {
  File file;
  Map<String, IfdTag>? exifData;

  CaptureImageModel({required this.file, this.exifData});
}