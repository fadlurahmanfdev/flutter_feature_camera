import 'dart:convert';

import 'package:example/presentation/preview_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class StreamCameraPage extends StatefulWidget {
  const StreamCameraPage({super.key});

  @override
  State<StreamCameraPage> createState() => _StreamCameraPageState();
}

class _StreamCameraPageState extends State<StreamCameraPage> with BaseFeatureCamera {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addListener(
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: onCameraInitializedFailure,
    );
    initializeCamera(cameraLensDirection: CameraLensDirection.front);
  }

  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Camera"),
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

  void onCameraInitialized() {
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

  Future<void> onImageStream(CameraImage cameraImage) async {
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
