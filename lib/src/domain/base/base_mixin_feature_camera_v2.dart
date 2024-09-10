import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_feature_camera/src/data/enum/enum_feature_camera_exception.dart';
import 'package:flutter_feature_camera/src/data/exception/feature_camera_exception.dart';
import 'package:image/image.dart' as image_lib;

mixin class BaseMixinFeatureCameraV2 {
  CameraController? cameraController;

  final List<CameraDescription> _cameraAvailable = [];
  late CameraLensDirection currentCameraLensDirection;

  void Function(CameraController controller)? _onCameraInitialized;
  void Function(FeatureCameraException exception)? _onCameraInitializedFailure;
  void Function(FlashMode mode)? _onFlashModeChanged;

  void addListener({
    void Function(FlashMode mode)? onFlashModeChanged,
  }) {
    _onFlashModeChanged = onFlashModeChanged;
  }

  Future<void> _initCameraAvailable() async {
    final camerasAvailable = await availableCameras();
    _cameraAvailable.addAll(camerasAvailable);
  }

  Future<CameraDescription?> _getCameraBasedOnFacingType(CameraLensDirection cameraLensDirection) async {
    if (_cameraAvailable.isEmpty) {
      await _initCameraAvailable();
    }

    CameraDescription? selectedCameraDescription;
    for (final camera in _cameraAvailable) {
      if (camera.lensDirection == cameraLensDirection) {
        selectedCameraDescription = camera;
        break;
      }
    }
    return selectedCameraDescription;
  }

  Future<bool> isCameraAvailable(CameraLensDirection cameraLensDirection) async {
    return await _getCameraBasedOnFacingType(cameraLensDirection) != null;
  }

  Future<void> _initializeCameraController(CameraLensDirection cameraLensDirection) async {
    CameraDescription? selectedCameraDescription = await _getCameraBasedOnFacingType(cameraLensDirection);

    if (selectedCameraDescription == null) {
      log("no camera with $cameraLensDirection available");
      return;
    }
    currentCameraLensDirection = cameraLensDirection;
    log("initialized camera with $cameraLensDirection");

    cameraController = CameraController(selectedCameraDescription, ResolutionPreset.high);
    cameraController!.initialize().then((_) {
      _onCameraInitialized?.call(cameraController!);
    }).catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _onCameraInitializedFailure?.call(
              FeatureCameraException(
                code: EnumFeatureCameraException.permission.name,
                message: 'give app access to camera permission',
              ),
            );
            break;
          default:
            _onCameraInitializedFailure?.call(
              FeatureCameraException(
                code: EnumFeatureCameraException.other.name,
                message: 'code: ${e.code}, message: ${e.description}',
              ),
            );
            break;
        }
      } else {
        _onCameraInitializedFailure?.call(FeatureCameraException(
          code: EnumFeatureCameraException.other.name,
          message: 'other exception: $e',
        ));
      }
    });
  }

  Future<void> initializeCamera({
    required CameraLensDirection cameraLensDirection,
    required void Function(CameraController controller) onCameraInitialized,
    void Function(FeatureCameraException exception)? onCameraInitializedFailure,
  }) async {
    _onCameraInitialized = onCameraInitialized;
    _onCameraInitializedFailure = onCameraInitializedFailure;

    if (_cameraAvailable.isEmpty) {
      await _initCameraAvailable();
    }

    _initializeCameraController(cameraLensDirection);
  }

  Future<void> switchCamera(CameraLensDirection cameraLensDirection) async {
    if (cameraController == null || _onCameraInitialized == null || _onCameraInitializedFailure == null) {
      log("failed to switch camera, camera didn't start yet");
      return;
    }

    if (cameraController?.value.isInitialized != true) {
      log("failed to switch camera, camera not yet initialized");
      return;
    }

    if (currentCameraLensDirection == cameraLensDirection) {
      log("cameraLensDirection already $cameraLensDirection");
      return;
    }

    if (currentFlashMode != FlashMode.off) {
      await setFlashMode(FlashMode.off);
    }

    _initializeCameraController(cameraLensDirection);
  }

  Future<void> resumeCamera({
    required void Function(CameraController controller) onCameraInitialized,
    void Function(FeatureCameraException exception)? onCameraInitializedFailure,
  }) async {
    return initializeCamera(
      cameraLensDirection: currentCameraLensDirection,
      onCameraInitialized: onCameraInitialized,
      onCameraInitializedFailure: onCameraInitializedFailure,
    );
  }

  Future<void> disposeCamera() async {
    if (currentFlashMode != FlashMode.off) {
      await setFlashMode(FlashMode.off);
    }

    _onCameraInitialized = null;
    _onCameraInitializedFailure = null;

    cameraController?.dispose();
    cameraController = null;
  }

  FlashMode currentFlashMode = FlashMode.off;

  Future<void> setFlashMode(FlashMode flashMode) async {
    if (currentFlashMode == flashMode) {
      log("flash mode same with current condition");
      return;
    }
    await cameraController?.setFlashMode(flashMode);
    currentFlashMode = flashMode;
    log("successfully update flashMode to $flashMode");
    if (_onFlashModeChanged != null) {
      _onFlashModeChanged?.call(flashMode);
    }
  }

  Future<File?> takePicture() async {
    if (cameraController == null) {
      log("unable to takePicture, cameraController missing");
      return null;
    }
    final xFile = await cameraController?.takePicture();
    if (xFile == null) return null;
    final newFile = File(xFile.path);
    if (Platform.isIOS) return newFile;
    final imageBytes = await xFile.readAsBytes();
    final originalImage = image_lib.decodeImage(imageBytes);
    if (originalImage == null) return null;
    if (currentCameraLensDirection == CameraLensDirection.back) return newFile;
    final fixedImage = image_lib.flipHorizontal(originalImage);
    await newFile.writeAsBytes(image_lib.encodeJpg(fixedImage), flush: true);
    return newFile;
  }

  Timer? timer;

  Future<void> startImageStream({required void Function(CameraImage image) onImageStream}) async {
    if (cameraController == null) {
      log("unable to startImageStream, cameraController missing");
      return;
    }
    cameraController?.startImageStream((image) {
      if (timer != null) return;
      timer = Timer(const Duration(seconds: 2), () {
        onImageStream(image);
        timer?.cancel();
        timer = null;
      });
    });
  }

  Future<void> stopImageStream() async {
    return cameraController?.stopImageStream();
  }
}
