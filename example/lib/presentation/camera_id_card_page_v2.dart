import 'dart:convert';

import 'package:example/presentation/preview_image_page.dart';
import 'package:example/presentation/widget/camera_control_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class CameraIdCardPageV2 extends StatefulWidget {
  const CameraIdCardPageV2({super.key});

  @override
  State<CameraIdCardPageV2> createState() => _CameraIdCardPageV2State();
}

class _CameraIdCardPageV2State extends State<CameraIdCardPageV2> with BaseMixinFeatureCameraV2 {
  CameraController? _cameraController;
  @override
  void initState() {
    super.initState();
    addListener(onFlashModeChanged: onFlashModeChanged);
    initializeCamera(
      cameraLensDirection: CameraLensDirection.back,
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: onCameraInitializedFailure,
    );
  }

  void onFlashModeChanged(FlashMode flashMode){
    setState(() {});
  }

  void onCameraInitialized(CameraController cameraController) {
    setState(() {
      _cameraController = cameraController;
    });
  }

  void onCameraInitializedFailure(FeatureCameraException exception) {}

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
            child: _cameraController?.value.isInitialized == true ? CameraPreview(_cameraController!) : Container(),
          ),
          IgnorePointer(
            child: CustomPaint(
              painter: RectanglePainterV2(),
              child: Container(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CameraControlLayoutWidget(
              flashIcon: flashModeState == FlashMode.always
                  ? Icon(Icons.flash_on)
                  : flashModeState == FlashMode.torch
                      ? Icon(Icons.flashlight_on)
                      : Icon(Icons.flash_off),
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
      final base64Encoded = base64.encode(bytes);
      if (mounted) {
        Navigator.of(context).pop(base64Encoded);
      }
    });
  }

  Future<void> onFlashTap() async {
    switch (flashModeState) {
      case FlashMode.off:
        setState(() {
          setFlashMode(FlashMode.always);
        });
        break;
      case FlashMode.always:
        setState(() {
          setFlashMode(FlashMode.torch);
        });
        break;
      case FlashMode.torch:
        setState(() {
          setFlashMode(FlashMode.off);
        });
        break;
      default:
        break;
    }
  }

  Future<void> onSwitchCameraTap() async {
    switch (cameraLensDirection) {
      case CameraLensDirection.front:
        switchCamera(CameraLensDirection.back);
      case CameraLensDirection.back:
        switchCamera(CameraLensDirection.front);
      default:
        break;
    }
  }
}
