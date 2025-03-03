import 'dart:convert';
import 'dart:developer';

import 'package:example/presentation/widget/camera_control_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class CameraSelfiePageV2 extends StatefulWidget {
  const CameraSelfiePageV2({super.key});

  @override
  State<CameraSelfiePageV2> createState() => _CameraSelfiePageV2State();
}

class _CameraSelfiePageV2State extends State<CameraSelfiePageV2> with BaseMixinFeatureCameraV2 {
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    addListener(
      onFlashModeChanged: onFlashModeChanged,
    );
    initializeCamera(
      cameraLensDirection: CameraLensDirection.front,
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: onCameraInitializedFailure,
    );
  }

  void onCameraInitializedFailure(FeatureCameraException exception) {}

  void onFlashModeChanged(FlashMode flashMode) {
    setState(() {});
  }

  void onCameraInitialized(CameraController cameraController) {
    setState(() {
      _cameraController = cameraController;
    });
  }

  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Selfie", style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: _cameraController?.value.isInitialized == true ? CameraPreview(_cameraController!) : Container(),
          ),
          IgnorePointer(
            child: CustomPaint(
              painter: CirclePainterV2(
                circleRadius: (Size size) => (size.width / 2.5),
              ), // Painter for black overlay with a transparent circle
              child: Container(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CameraControlLayoutWidget(
              flashIcon: Icon(Icons.flash_off),
              onFlashTap: onFlashTap,
              captureIcon: Icon(Icons.camera_alt),
              onCaptureTap: onCaptureTap,
              switchCameraIcon: Icon(Icons.autorenew),
              onSwitchCameraTap: onSwitchCameraTap,
            ),
          ),
        ],
      ),
    );
  }

  void onCaptureTap() {
    takePicture(includeExif: true).then((value) async {
      final bytes = await value.file.readAsBytes();
      if (value.exifData != null) {
        for (final entry in value.exifData!.entries) {
          log("exif data - ${entry.key}: ${entry.value}");
        }
      }
      final brightnessOfImage = calculateBrightness(bytes);
      log("brightness of image: $brightnessOfImage");
      final base64Encode = base64.encode(bytes);
      if (mounted) {
        Navigator.of(context).pop(base64Encode);
      }
    });
  }

  void onFlashTap() {}

  void onSwitchCameraTap() {}
}
