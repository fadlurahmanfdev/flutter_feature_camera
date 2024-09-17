import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';
import 'package:flutter_feature_camera/src/data/enum/enum_feature_camera_exception.dart';
import 'package:flutter_feature_camera/src/data/exception/feature_camera_exception.dart';
import 'package:image/image.dart' as image_lib;

/// BaseMixinFeatureCameraV2 is a mixin class designed to facilitate camera-related functionalities.
/// It provides methods for handling essential camera features, such as initializing the camera, taking pictures,
/// switching between cameras, setting flash modes, starting and stopping image streams, and more.
///
/// This mixin can be used in widgets or classes where camera functionality is required, allowing for
/// streamlined integration of camera operations in Flutter applications.
mixin BaseMixinFeatureCameraV2 {
  /// The current [CameraController] to control the camera hardware.
  CameraController? cameraController;

  final List<CameraDescription> _cameraAvailable = [];

  /// The list of available camera.
  /// do not forget to initialized it using [initializeCamera] or [initializeStreamingCamera]
  List<CameraDescription> get cameraAvailable => _cameraAvailable;

  /// The direction of the currently active camera (front or back).
  late CameraLensDirection currentCameraLensDirection;
  late CameraDescription _cameraDescription;
  ImageFormatGroup? _currentImageFormatGroup;
  ResolutionPreset _currentResolutionPreset = ResolutionPreset.high;

  void Function(CameraController controller)? _onCameraInitialized;
  void Function(FeatureCameraException exception)? _onCameraInitializedFailure;
  void Function(FlashMode mode)? _onFlashModeChanged;

  /// Registers event listeners for camera features.
  ///
  /// - [onFlashModeChanged] is triggered when the flash mode is changed.
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

  /// Checks if a camera with the specified [cameraLensDirection] is available.
  ///
  /// This method returns `true` if a camera matching the given direction is found,
  /// and `false` if no such camera is available.
  ///
  /// Example usage:
  /// ```dart
  /// bool isAvailable = await isCameraAvailable(CameraLensDirection.front);
  /// ```
  Future<bool> isCameraAvailable(CameraLensDirection cameraLensDirection) async {
    return await _getCameraBasedOnFacingType(cameraLensDirection) != null;
  }

  Future<void> _initializeCameraController({
    required CameraLensDirection cameraLensDirection,
    required ResolutionPreset resolutionPreset,
    bool enableAudio = true,
    ImageFormatGroup? imageFormatGroup,
  }) async {
    CameraDescription? selectedCameraDescription = await _getCameraBasedOnFacingType(cameraLensDirection);

    if (selectedCameraDescription == null) {
      log("no camera with $cameraLensDirection available");
      return;
    }
    _cameraDescription = selectedCameraDescription;
    log("initialized cameraDescription with $selectedCameraDescription");

    currentCameraLensDirection = cameraLensDirection;
    log("initialized camera with $cameraLensDirection");

    _currentImageFormatGroup = imageFormatGroup;
    log("initialized imageFormatGroup with $imageFormatGroup");

    _currentResolutionPreset = resolutionPreset;
    log("initialized resolutionPreset with: $resolutionPreset");

    cameraController = CameraController(
      selectedCameraDescription,
      enableAudio: enableAudio,
      resolutionPreset,
      imageFormatGroup: imageFormatGroup,
    );
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

  /// Initializes the camera with the specified [CameraLensDirection] and handles success or failure callbacks.
  ///
  /// - [cameraLensDirection] specifies whether to use the front or rear camera.
  /// - [onCameraInitialized] is called when the camera is successfully initialized.
  /// - [onCameraInitializedFailure] is called when the camera fails to initialize.
  Future<void> initializeCamera({
    required CameraLensDirection cameraLensDirection,
    required void Function(CameraController controller) onCameraInitialized,
    void Function(FeatureCameraException exception)? onCameraInitializedFailure,
    ResolutionPreset resolutionPreset = ResolutionPreset.high,
    bool enableAudio = true,
    ImageFormatGroup? imageFormatGroup,
  }) async {
    _onCameraInitialized = onCameraInitialized;
    _onCameraInitializedFailure = onCameraInitializedFailure;

    if (_cameraAvailable.isEmpty) {
      await _initCameraAvailable();
    }

    _initializeCameraController(
      cameraLensDirection: cameraLensDirection,
      resolutionPreset: resolutionPreset,
      enableAudio: enableAudio,
      imageFormatGroup: imageFormatGroup,
    );
  }

  Future<void> initializeStreamingCamera({
    required CameraLensDirection cameraLensDirection,
    required void Function(CameraController controller) onCameraInitialized,
    void Function(FeatureCameraException exception)? onCameraInitializedFailure,
  }) async {
    return initializeCamera(
      cameraLensDirection: cameraLensDirection,
      onCameraInitialized: onCameraInitialized,
      enableAudio: false,
      resolutionPreset: ResolutionPreset.medium,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
  }

  /// Switches the active camera to the specified [CameraLensDirection] (front or rear).
  ///
  /// If the camera is not initialized or the selected camera is already active, the function will log an error.
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

    _initializeCameraController(
      cameraLensDirection: cameraLensDirection,
      resolutionPreset: _currentResolutionPreset,
      imageFormatGroup: _currentImageFormatGroup,
    );
  }

  /// Resumes the camera with the last-used [CameraLensDirection] and initializes it.
  ///
  /// - [onCameraInitialized] is called when the camera is successfully initialized.
  /// - [onCameraInitializedFailure] is called when the camera fails to initialize.
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

  /// Disposes the active camera and resets flash mode to off.
  Future<void> disposeCamera() async {
    if (currentFlashMode != FlashMode.off) {
      await setFlashMode(FlashMode.off);
    }

    _onCameraInitialized = null;
    _onCameraInitializedFailure = null;

    cameraController?.dispose();
    cameraController = null;
  }

  /// The current flash mode of the camera (on, off, auto, etc.).
  FlashMode currentFlashMode = FlashMode.off;

  /// Sets the camera's flash mode to the specified [flashMode] (off, on, auto, etc.).
  ///
  /// - If the current flash mode is already the desired one, no action is taken.
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

  /// Captures a picture using the active camera and returns the file.
  ///
  /// - If the camera controller is not initialized, this function will log an error and return null.
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

  Timer? _streamImageTimer;

  bool _isStreamingImage = false;

  bool get isStreamingImage => _isStreamingImage;

  /// Starts streaming the camera image data and triggers [onImageStream] every two seconds.
  ///
  /// - [onImageStream] is called with the camera image at regular intervals.
  Future<void> startImageStream({
    required void Function(
      CameraImage image,
      int sensorOrientation,
      DeviceOrientation deviceOrientation,
      CameraLensDirection cameraLensDirection,
    ) onImageStream,
  }) async {
    if (cameraController == null) {
      log("unable to startImageStream, cameraController missing");
      return;
    }

    if (_isStreamingImage) {
      log("unable to startImageStream, already startImageStream");
      return;
    }

    cameraController?.startImageStream((image) {
      _isStreamingImage = true;

      if (_streamImageTimer != null) return;
      _streamImageTimer = Timer(const Duration(seconds: 2), () {
        onImageStream(
          image,
          _cameraDescription.sensorOrientation,
          cameraController?.value.deviceOrientation ?? DeviceOrientation.portraitUp,
          currentCameraLensDirection,
        );
        _streamImageTimer?.cancel();
        _streamImageTimer = null;
      });
    });
    log("successfully startImageStream");
  }

  /// Stops the image stream from the camera.
  Future<void> stopImageStream() async {
    _isStreamingImage = false;
    _streamImageTimer?.cancel();
    _streamImageTimer = null;
    await cameraController?.stopImageStream();
    log("successfully stopImageStream");
  }
}
