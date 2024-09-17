import 'dart:convert';

import 'package:example/presentation/preview_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class StreamCameraPage extends StatefulWidget {
  const StreamCameraPage({super.key});

  @override
  State<StreamCameraPage> createState() => _StreamCameraPageState();
}

class _StreamCameraPageState extends State<StreamCameraPage> with BaseMixinFeatureCameraV2 {
  @override
  void initState() {
    super.initState();
    initializeStreamingCamera(
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: onCameraInitializedFailure,
      cameraLensDirection: CameraLensDirection.front,
    );
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Streaming Camera"),
      ),
      body: Stack(
        children: [
          cameraController?.value.isInitialized == true ? CameraPreview(cameraController!) : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _controlLayout(),
          )
        ],
      ),
    );
  }

  void onCameraInitialized(CameraController controller) {
    setState(() {});
  }

  void onCameraInitializedFailure(FeatureCameraException exception) {}

  bool isStartStreamingImage = false;

  Widget _controlLayout() {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(bottom: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (!isStartStreamingImage) {
                  setState(() {
                    isStartStreamingImage = !isStartStreamingImage;
                  });
                  startImageStream(onImageStream: onImageStream);
                }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: isStartStreamingImage ? Icon(Icons.stop) : Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onImageStream(
    CameraImage cameraImage,
    int sensorOrientation,
    DeviceOrientation deviceOrientation,
    CameraLensDirection cameraLensDirection,
  ) async {
    stopImageStream().then((_) async {
      final file = await takePicture();
      // final byte = await convert_native.ConvertNativeImgStream()
      //     .convertImgToBytes(cameraImage.planes.first.bytes, cameraImage.width, cameraImage.height);
      final base64Encode = base64.encode(await file!.readAsBytes());
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PreviewImagePage(base64Image: base64Encode)));
      }
    });
  }
}
