import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_feature_camera/src/data/enum/feature_camera_facing_type.dart';
import 'package:flutter_feature_camera/src/data/exception/feature_camera_exception.dart';

mixin class BaseFeatureCamera {
  CameraController? cameraController;

  final List<CameraDescription> _cameraAvailable = [];
  late CameraLensDirection cameraLensDirection;
  late FeatureCameraFacingType cameraFacingType;

  void Function()? _onCameraInitialized;
  void Function(FeatureCameraException exception)? _onCameraInitializedFailure;

  void addListener({
    void Function()? onCameraInitialized,
    void Function(FeatureCameraException exception)? onCameraInitializedFailure,
  }) {
    _onCameraInitialized = onCameraInitialized;
    _onCameraInitializedFailure = onCameraInitializedFailure;
  }

  Future<void> _initCameraAvailable() async {
    final camerasAvailable = await availableCameras();
    _cameraAvailable.addAll(camerasAvailable);
  }

  Future<CameraDescription?> _getCameraBasedOnFacingType(FeatureCameraFacingType facingType) async {
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

  Future<bool> isCameraAvailable(FeatureCameraFacingType facingType) async {
    return await _getCameraBasedOnFacingType(facingType) != null;
  }

  Future<void> initializeCamera({required FeatureCameraFacingType facingType}) async {
    if (_cameraAvailable.isEmpty) {
      await _initCameraAvailable();
    }

    cameraFacingType = facingType;
    cameraLensDirection = switch (facingType) {
      FeatureCameraFacingType.front => CameraLensDirection.front,
      FeatureCameraFacingType.back => CameraLensDirection.back,
    };

    CameraDescription? selectedCameraDescription = await _getCameraBasedOnFacingType(cameraFacingType);

    if (selectedCameraDescription == null) {
      log("no camera with $facingType available");
      return;
    }

    cameraController = CameraController(selectedCameraDescription, ResolutionPreset.high);
    cameraController!.initialize().then((_) {
      _onCameraInitialized?.call();
    }).catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _onCameraInitializedFailure?.call(
              FeatureCameraException(
                code: 'PERMISSION',
                message: 'give app access to camera permission',
              ),
            );
            break;
          default:
            _onCameraInitializedFailure?.call(
              FeatureCameraException(
                code: 'CAMERA_EXCEPTION',
                message: 'code: ${e.code}, message: ${e.description}',
              ),
            );
            break;
        }
      } else {
        _onCameraInitializedFailure?.call(FeatureCameraException(code: 'OTHER', message: 'other exception: $e'));
      }
    });
  }

  Future<void> resumeCamera() async {
    if (_tempOnCameraInitialized != null) {
      _onCameraInitialized = _tempOnCameraInitialized;
      _tempOnCameraInitialized = null;
    }

    if (_tempOnCameraInitializedFailure != null) {
      _onCameraInitializedFailure = _tempOnCameraInitializedFailure;
      _tempOnCameraInitializedFailure = null;
    }

    return initializeCamera(facingType: cameraFacingType);
  }

  void Function()? _tempOnCameraInitialized;
  void Function(FeatureCameraException exception)? _tempOnCameraInitializedFailure;

  void disposeCamera() {
    _tempOnCameraInitialized = _onCameraInitialized;
    _onCameraInitialized = null;
    _tempOnCameraInitializedFailure = _onCameraInitializedFailure;
    _onCameraInitializedFailure = null;

    cameraController?.dispose();
    cameraController = null;
  }

  Future<XFile?> takePicture() async {
    if (cameraController == null) {
      log("unable to takePicture, cameraController missing");
      return null;
    }
    return cameraController?.takePicture();
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
