import 'dart:convert';

import 'package:example/presentation/preview_image_page.dart';
import 'package:example/presentation/widget/camera_control_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class CaptureImagePage extends StatefulWidget {
  const CaptureImagePage({super.key});

  @override
  State<CaptureImagePage> createState() => _CaptureImagePageState();
}

class _CaptureImagePageState extends State<CaptureImagePage> with BaseMixinFeatureCameraV2 {
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    addListener(
      onFlashModeChanged: onFlashModeChanged,
    );
    initializeCamera(
      cameraLensDirection: CameraLensDirection.back,
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
        title: const Text("Camera Capture", style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: _cameraController?.value.isInitialized == true
                ? GestureDetector(
                    onTapUp: (detail) {

                      final dx = detail.localPosition.dx;
                      final dy = detail.localPosition.dy;

                      double fullWidth = MediaQuery.of(context).size.width;
                      double cameraHeight = fullWidth * _cameraController!.value.aspectRatio;

                      double xp = dx / fullWidth;
                      double yp = dy / cameraHeight;

                      print("masuk x: ${detail.localPosition.dx}");
                      print("masuk xp: $xp");
                      print("masuk y: ${detail.localPosition.dy}");
                      print("masuk yp: $yp");

                      _cameraController?.setFocusPoint(Offset(xp, yp));
                    },
                    child: CameraPreview(_cameraController!))
                : Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CameraControlLayoutWidget(
              flashIcon: switch (flashModeState) {
                FlashMode.off => Icon(Icons.flash_off),
                FlashMode.auto => Icon(Icons.flash_auto),
                FlashMode.always => Icon(Icons.flash_on),
                FlashMode.torch => Icon(Icons.flash_on),
              },
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
    takePicture().then((value) async {
      final bytes = await value.file.readAsBytes();
      final base64Encoded = base64.encode(bytes);
      if (mounted) {
        Navigator.of(context).pop(base64Encoded);
      }
    });
  }

  void onFlashTap() {
    if (flashModeState == FlashMode.off) {
      setFlashMode(FlashMode.always);
    } else {
      setFlashMode(FlashMode.off);
    }
  }

  void onSwitchCameraTap() {
    disposeCamera();
    if (cameraLensDirection == CameraLensDirection.back) {
      switchCamera(CameraLensDirection.front);
    } else {
      switchCamera(CameraLensDirection.back);
    }
  }
}
