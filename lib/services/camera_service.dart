import 'package:camera/camera.dart';

class CameraService {
  CameraController? controller;

  List<CameraDescription> cameras = [];

  int _currentCameraIndex = 0;

  CameraController? get cameraController => controller;

  CameraDescription? get currentCamera {
    if (cameras.isEmpty) {
      return null;
    }

    return cameras[_currentCameraIndex];
  }

  bool get isInitialized =>
      controller?.value.isInitialized ?? false;

  // ============================================================
  // INITIALIZE CAMERA
  // ============================================================

  Future<void> initialize() async {
    cameras = await availableCameras();

    if (cameras.isEmpty) {
      throw Exception(
        'No camera was found on this device.',
      );
    }

    // Prefer back camera
    final backCameraIndex = cameras.indexWhere(
          (camera) =>
      camera.lensDirection == CameraLensDirection.back,
    );

    if (backCameraIndex != -1) {
      _currentCameraIndex = backCameraIndex;
    } else {
      _currentCameraIndex = 0;
    }

    await _initializeCamera(
      cameras[_currentCameraIndex],
    );
  }

  // ============================================================
  // CREATE CAMERA CONTROLLER
  // ============================================================

  Future<void> _initializeCamera(
      CameraDescription camera,
      ) async {
    // Dispose old controller before creating new one
    await controller?.dispose();

    controller = CameraController(
      camera,

      // High gives better image quality than medium.
      // ML Kit will still process the live stream.
      ResolutionPreset.high,

      enableAudio: false,

      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await controller!.initialize();
    } catch (e) {
      await controller?.dispose();
      controller = null;

      throw Exception(
        'Unable to initialize camera: $e',
      );
    }
  }

  // ============================================================
  // START IMAGE STREAM
  // ============================================================

  Future<void> startImageStream(
      void Function(CameraImage image) onImage,
      ) async {
    if (controller == null ||
        !controller!.value.isInitialized) {
      throw Exception(
        'Camera is not initialized.',
      );
    }

    if (controller!.value.isStreamingImages) {
      return;
    }

    await controller!.startImageStream(
      onImage,
    );
  }

  // ============================================================
  // STOP IMAGE STREAM
  // ============================================================

  Future<void> stopImageStream() async {
    if (controller == null) {
      return;
    }

    if (controller!.value.isStreamingImages) {
      await controller!.stopImageStream();
    }
  }

  // ============================================================
  // FLASH
  // ============================================================

  Future<void> toggleFlash(
      bool enabled,
      ) async {
    if (controller == null ||
        !controller!.value.isInitialized) {
      return;
    }

    await controller!.setFlashMode(
      enabled
          ? FlashMode.torch
          : FlashMode.off,
    );
  }

  // ============================================================
  // SWITCH CAMERA
  // ============================================================

  Future<void> switchCamera() async {
    if (cameras.length < 2) {
      throw Exception(
        'Another camera is not available.',
      );
    }

    await stopImageStream();

    _currentCameraIndex =
        (_currentCameraIndex + 1) % cameras.length;

    await _initializeCamera(
      cameras[_currentCameraIndex],
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    await stopImageStream();

    await controller?.dispose();

    controller = null;
  }
}