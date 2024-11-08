
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class CaptureImagePage extends StatefulWidget {
  const CaptureImagePage({super.key});

  @override
  State<CaptureImagePage> createState() => _CaptureImagePageState();
}

class _CaptureImagePageState extends State<CaptureImagePage> with BaseMixinFeatureCameraV2 {
  @override
  void initState() {
    super.initState();
    // addListener(
    //   onCameraInitialized: (_) {
    //     setState(() {});
    //   },
    //   onFlashModeChanged: (flashMode) {
    //     setState(() {});
    //   },
    // );
    // initializeCamera(cameraLensDirection: CameraLensDirection.back);
  }

  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Camera Capture", style: TextStyle(color: Colors.black)),
    //   ),
    //   body: Stack(
    //     children: [
    //       Container(
    //         alignment: Alignment.center,
    //         child: cameraController?.value.isInitialized == true ? CameraPreview(cameraController!) : Container(),
    //       ),
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: CameraControlLayoutWidget(
    //           flashIcon: switch (currentFlashMode) {
    //             FlashMode.off => Icon(Icons.flash_off),
    //             FlashMode.auto => Icon(Icons.flash_auto),
    //             FlashMode.always => Icon(Icons.flash_on),
    //             FlashMode.torch => Icon(Icons.flash_on),
    //           },
    //           onFlashTap: onFlashTap,
    //           captureIcon: Icon(Icons.camera_alt),
    //           onCaptureTap: onCaptureTap,
    //           switchCameraIcon: Icon(Icons.autorenew),
    //           onSwitchCameraTap: onSwitchCameraTap,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void onCaptureTap() {
    // takePicture().then((value) async {
    //   final bytes = await value?.readAsBytes();
    //   if (bytes != null) {
    //     final base64Encode = base64.encode(bytes);
    //     if (mounted) {
    //       Navigator.of(context).push(MaterialPageRoute(builder: (_) => PreviewImagePage(base64Image: base64Encode)));
    //     }
    //   }
    // });
  }

  void onFlashTap() {
    // if (currentFlashMode == FlashMode.off) {
    //   setFlashMode(FlashMode.always);
    // } else {
    //   setFlashMode(FlashMode.off);
    // }
  }

  void onSwitchCameraTap() {
    // disposeCamera();
    // if (currentCameraLensDirection == CameraLensDirection.back) {
    //   initializeCamera(cameraLensDirection: CameraLensDirection.front);
    // } else {
    //   initializeCamera(cameraLensDirection: CameraLensDirection.back);
    // }
  }
}
