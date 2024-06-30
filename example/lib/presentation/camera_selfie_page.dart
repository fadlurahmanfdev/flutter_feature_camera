import 'dart:convert';

import 'package:example/presentation/preview_image_page.dart';
import 'package:example/presentation/widget/camera_control_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class CameraSelfiePage extends StatefulWidget {
  const CameraSelfiePage({super.key});

  @override
  State<CameraSelfiePage> createState() => _CameraSelfiePageState();
}

class _CameraSelfiePageState extends State<CameraSelfiePage> with BaseFeatureCamera {
  @override
  void initState() {
    super.initState();
    addListener(onCameraInitialized: () {
      setState(() {});
    }, onFlashModeChanged: (flashMode) {
      print("masuk flash mode: $flashMode");
      setState(() {});
    });
    initializeCamera(cameraLensDirection: CameraLensDirection.front);
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
            child: cameraController?.value.isInitialized == true ? CameraPreview(cameraController!) : Container(),
          ),
          IgnorePointer(
            child: ClipPath(
              clipper: CircleClipper(),
              child: CustomPaint(
                painter: CirclePainter(),
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
