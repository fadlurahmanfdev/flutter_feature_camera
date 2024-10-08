import 'dart:convert';

import 'package:example/presentation/preview_image_page.dart';
import 'package:example/presentation/widget/camera_control_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class CameraIdCardPage extends StatefulWidget {
  const CameraIdCardPage({super.key});

  @override
  State<CameraIdCardPage> createState() => _CameraIdCardPageState();
}

class _CameraIdCardPageState extends State<CameraIdCardPage> with BaseMixinFeatureCamera {
  @override
  void initState() {
    super.initState();
    addListener(
      onCameraInitialized: (_) {
        setState(() {});
      },
      onFlashModeChanged: (flashMode) {
        setState(() {});
      },
    );
    initializeCamera(cameraLensDirection: CameraLensDirection.back);
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
        title: const Text("Camera ID Card Page", style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: cameraController?.value.isInitialized == true ? CameraPreview(cameraController!) : Container(),
          ),
          IgnorePointer(
            child: ClipPath(
              clipper: RectangleClipper(),
              child: CustomPaint(
                painter: RectanglePainter(),
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
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
    takePicture().then((value) async {
      final bytes = await value?.readAsBytes();
      if (bytes != null) {
        final base64Encode = base64.encode(bytes);
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => PreviewImagePage(base64Image: base64Encode)));
        }
      }
    });
  }

  void onFlashTap() {}

  void onSwitchCameraTap() {}
}
