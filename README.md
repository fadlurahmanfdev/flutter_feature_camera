# Description

A Flutter library provides methode, abstract class, etc related for camera functionality,
including capturing images, managing flash modes, switching between front and back cameras, and
enabling image streaming.

## Key Features

### Rectangle Overlay

A custom painter that draws a semi-transparent overlay with a centered rectangular cutout,
typically used as a camera overlay to highlight the area for capturing ID cards or documents.

The `RectanglePainterV2` class paints an overlay on the screen with a clear rectangle in the center,
allowing users to focus on the content within the rectangle (e.g., for taking ID card photos).

### Circle Overlay

A custom painter that draws a semi-transparent overlay with a circular cutout and optional progress
arc,
typically used as an overlay for selfie cameras to focus on the subject in the center of the screen.

The `CirclePainterV2` class is designed to paint an overlay on the screen with a clear circle in the
center,
making it suitable for use in selfie camera applications, or any use case that requires a circular
overlay.
Additionally, it supports drawing a progress arc around the circle, which can be useful for
indicating capture progress.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Camera ID Card Page", style: TextStyle(color: Colors.black)),
    ),
    body: Stack(
      children: [
        // Camera preview area
        Container(
          alignment: Alignment.center,
          child: cameraController?.value.isInitialized == true
              ? CameraPreview(cameraController!)
              : Container(),
        ),
        // Overlay rectangle for ID card capture
        IgnorePointer(
          child: CustomPaint(
            painter: RectanglePainterV2(),
            child: Container(),
          ),
        ),
      ],
    ),
  );
}
```

<table>
  <tr>
    <td>
		<img alt="Circle Overlay" width="250px" src="https://raw.githubusercontent.com/fadlurahmanfdev/flutter_feature_face_detection/master/media/circle_overlay.png">
    </td>
  </tr>
</table>

### Base Camera

`BaseMixinFeatureCameraV2` is a mixin class designed to facilitate camera-related
functionalities.
It provides methods for handling essential camera features, such as initializing the camera, taking
pictures,
switching between cameras, setting flash modes, starting and stopping image streams, and more.

This mixin can be used in widgets or classes where camera functionality is required, allowing for
streamlined integration of camera operations in Flutter applications.

### Check Is Camera Available

Checks if a camera with the specified `cameraLensDirection` is available.

This function available inside `BaseMixinFeatureCameraV2`.

```dart
final isCameraAvailable = isCameraAvailable(CameraLensDirection.back);
```

| Parameter Name        | Type                | Required | Description                                                                                                                               |
|-----------------------|---------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `cameraLensDirection` | CameraLensDirection | Yes      | The direction the camera is facing. Possibility value (CameraLensDirection.back, CameraLensDirection.front, CameraLensDirection.external) |

### Switch Camera Lens Direction

Switches the active camera to the specified `CameraLensDirection`.

This function available inside `BaseMixinFeatureCameraV2`.

```dart
void screenFunction() {
  switchCamera(CameraLensDirection.back); 
}
```

| Parameter Name        | Type                | Required | Description                                                                                                                               |
|-----------------------|---------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `cameraLensDirection` | CameraLensDirection | Yes      | The direction the camera is facing. Possibility value (CameraLensDirection.back, CameraLensDirection.front, CameraLensDirection.external) |

### Set Flash Mode

Sets the camera's flash mode to the specified `flashMode` (off, on, auto, etc.).

This function available inside `BaseMixinFeatureCameraV2`.

```dart
void screenFunction() {
  setFlashMode(FlashMode.always); 
}
```

| Parameter Name | Type       | Required | Description                                                                                                                                 |
|----------------|------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `flashMode`    | FlashMode  | Yes      | The possible flash modes that can be set for a camera. Possibility value (FlashMode.off, FlashMode.auto, FlashMode.always, FlashMode.torch) |

### Take Picture

Captures a picture using the active camera and returns the file.

This function available inside `BaseMixinFeatureCameraV2`.

```dart
void screenFunction() {
  takePicture();
}
```

### Stream Camera

Starts streaming the camera image data and triggers `onImageStream` every two seconds.

This function available inside `BaseMixinFeatureCameraV2`.

```dart
void startStreamCamera() {
  startImageStream(onImageStream: onImageStream);
}

Future<void> onImageStream(CameraImage cameraImage, 
    int sensorOrientation,
    DeviceOrientation deviceOrientation,
    CameraLensDirection cameraLensDirection,) async {
  // process streaming image here
}
```

## Getting started

### Android

```gradle
android {
    // ... other code
    
    defaultConfig {
        minSdkVersion 21 // change minSdkVersion to 21
    }
}
```

## Usage

### Rectangle Overlay

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Camera ID Card Page", style: TextStyle(color: Colors.black)),
    ),
    body: Stack(
      children: [
        // Camera preview area
        Container(
          alignment: Alignment.center,
          child: cameraController?.value.isInitialized == true
              ? CameraPreview(cameraController!)
              : Container(),
        ),
        // Overlay rectangle for ID card capture
        IgnorePointer(
          child: CustomPaint(
            painter: RectanglePainterV2(),
            child: Container(),
          ),
        ),
      ],
    ),
  );
}
```

### Base Camera

For more detailed examples, refer to
the [example](https://github.com/fadlurahmanfdev/flutter_feature_camera/blob/master/example/lib/presentation).

```dart
class CustomCameraPage extends StatefulWidget {
  const CustomCameraPage({super.key});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage> with BaseMixinFeatureCameraV2 {

  @override
  void initState() {
    super.initState();
    addListener(onFlashModeChanged: onFlashModeChanged);
    initializeCamera(
      cameraLensDirection: CameraLensDirection.back,
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: (FeatureCameraException exception) {},
    );
  }

  void onCameraInitialized(CameraController controller) {
    setState(() {});
  }
}
```

### Base Camera - Streaming Camera

For more detailed examples, refer to
the [example](https://github.com/fadlurahmanfdev/flutter_feature_camera/blob/master/example/lib/presentation).

```dart
class CustomCameraPage extends StatefulWidget {
  const CustomCameraPage({super.key});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage> with BaseMixinFeatureCameraV2 {

  @override
  void initState() {
    super.initState();
    addListener(onFlashModeChanged: onFlashModeChanged);
    initializeStreamingCamera(
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: (FeatureCameraException exception) {},
      cameraLensDirection: CameraLensDirection.front,
    );
  }

  void onCameraInitialized(CameraController controller) {
    setState(() {});
  }
}
```
