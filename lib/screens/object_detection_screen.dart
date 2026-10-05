

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../models/detection_result.dart';
import '../services/camera_service.dart';
import '../services/object_detection_service.dart';
import '../widgets/camera_controls.dart';
import '../widgets/detection_box.dart';
import '../widgets/detection_info_card.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() =>
      _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState
    extends State<ObjectDetectionScreen> {
  // ============================================================
  // SERVICES
  // ============================================================

  final CameraService _cameraService = CameraService();

  final ObjectDetectionService _detectionService =
  ObjectDetectionService();

  // ============================================================
  // CAMERA / DETECTION STATE
  // ============================================================

  bool _cameraReady = false;
  bool _detecting = false;
  bool _flashOn = false;
  bool _switchingCamera = false;

  String? _error;

  List<DetectionResult> _detections = [];

  // ============================================================
  // STABILITY
  // ============================================================

  // Keeps the last valid detection visible for a short time.
  // This prevents boxes from disappearing whenever one frame
  // temporarily returns no result.
  Timer? _detectionClearTimer;

  // Prevents too many UI updates.
  DateTime _lastUiUpdate = DateTime.fromMillisecondsSinceEpoch(0);

  // UI update interval.
  static const Duration _uiUpdateInterval =
  Duration(milliseconds: 120);

  // Keep detection on screen for this duration if one frame
  // temporarily returns no result.
  static const Duration _detectionHoldDuration =
  Duration(milliseconds: 500);

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  // ============================================================
  // INITIALIZE CAMERA
  // ============================================================

  Future<void> _initialize() async {
    try {
      if (mounted) {
        setState(() {
          _cameraReady = false;
          _error = null;
        });
      }

      await _cameraService.initialize();

      if (!mounted) return;

      setState(() {
        _cameraReady = true;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cameraReady = false;
        _error = e.toString();
      });
    }
  }

  // ============================================================
  // START DETECTION
  // ============================================================

  Future<void> _startDetection() async {
    if (!_cameraReady || _detecting) {
      return;
    }

    _detectionClearTimer?.cancel();

    setState(() {
      _detecting = true;
      _detections = [];
    });

    try {
      await _cameraService.startImageStream(
            (CameraImage image) async {
          if (!_detecting) {
            return;
          }

          final CameraDescription? camera =
              _cameraService.currentCamera;

          if (camera == null) {
            return;
          }

          try {
            final List<DetectionResult> results =
            await _detectionService.processCameraImage(
              image,
              camera,
            );

            if (!mounted || !_detecting) {
              return;
            }

            _updateDetections(results);
          } catch (e) {
            // Detection service handles ML Kit errors.
            // We intentionally don't clear the UI here.
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _detecting = false;
      });

      _showError(
        'Could not start object detection.',
      );
    }
  }

  // ============================================================
  // STABLE DETECTION UPDATE
  // ============================================================

  void _updateDetections(
      List<DetectionResult> results) {
    if (!mounted || !_detecting) {
      return;
    }

    // ----------------------------------------------------------
    // VALID RESULT
    // ----------------------------------------------------------

    if (results.isNotEmpty) {
      _detectionClearTimer?.cancel();

      final DateTime now = DateTime.now();

      // Avoid rebuilding UI on every camera frame.
      if (now.difference(_lastUiUpdate) <
          _uiUpdateInterval) {
        return;
      }

      _lastUiUpdate = now;

      setState(() {
        _detections = results;
      });

      // --------------------------------------------------------
      // TEMPORARILY NO RESULT
      // --------------------------------------------------------

      return;
    }

    // ----------------------------------------------------------
    // EMPTY RESULT
    //
    // DO NOT immediately clear detections.
    // This is the main reason for blinking.
    // ----------------------------------------------------------

    _detectionClearTimer?.cancel();

    _detectionClearTimer = Timer(
      _detectionHoldDuration,
          () {
        if (!mounted || !_detecting) {
          return;
        }

        setState(() {
          _detections = [];
        });
      },
    );
  }

  // ============================================================
  // STOP DETECTION
  // ============================================================

  Future<void> _stopDetection() async {
    _detectionClearTimer?.cancel();

    try {
      await _cameraService.stopImageStream();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _detecting = false;
      _detections = [];
    });
  }

  // ============================================================
  // FLASH
  // ============================================================

  Future<void> _toggleFlash() async {
    try {
      final bool newValue = !_flashOn;

      await _cameraService.toggleFlash(
        newValue,
      );

      if (!mounted) return;

      setState(() {
        _flashOn = newValue;
      });
    } catch (_) {
      _showError(
        'Flash is not available on this camera.',
      );
    }
  }

  // ============================================================
  // SWITCH CAMERA
  // ============================================================

  Future<void> _switchCamera() async {
    if (_switchingCamera) {
      return;
    }

    try {
      setState(() {
        _switchingCamera = true;
      });

      final bool restartDetection = _detecting;

      if (_detecting) {
        await _stopDetection();
      }

      await _cameraService.switchCamera();

      if (!mounted) return;

      setState(() {
        _flashOn = false;
        _switchingCamera = false;
      });

      if (restartDetection) {
        await Future.delayed(
          const Duration(milliseconds: 250),
        );

        if (!mounted) return;

        await _startDetection();
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _switchingCamera = false;
      });

      _showError(
        'Unable to switch camera.',
      );
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _detecting = false;

    _detectionClearTimer?.cancel();

    _detectionService.dispose();
    _cameraService.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _errorScreen();
    }

    if (!_cameraReady) {
      return _loadingScreen();
    }

    final CameraController? controller =
        _cameraService.cameraController;

    if (controller == null ||
        !controller.value.isInitialized) {
      return _loadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ====================================================
          // CAMERA
          // ====================================================

          Positioned.fill(
            child: _cameraPreview(controller),
          ),

          // ====================================================
          // TOP GRADIENT
          // ====================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 220,
                decoration:
                const BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                    Alignment.topCenter,
                    end:
                    Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ====================================================
          // BOTTOM GRADIENT
          // ====================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 260,
                decoration:
                const BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                    Alignment.bottomCenter,
                    end:
                    Alignment.topCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ====================================================
          // HEADER
          // ====================================================

          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                0,
              ),
              child: _header(),
            ),
          ),

          // ====================================================
          // DETECTION BOXES
          // ====================================================

          if (_detecting &&
              _detections.isNotEmpty)
            ..._buildDetectionBoxes(),

          // ====================================================
          // SCANNING
          // ====================================================

          if (_detecting &&
              _detections.isEmpty)
            _scanningIndicator(),

          // ====================================================
          // DETECTION INFO
          // ====================================================

          if (_detecting &&
              _detections.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 155,
              child: SafeArea(
                top: false,
                child: _infoCard(),
              ),
            ),

          // ====================================================
          // READY CARD
          // ====================================================

          if (!_detecting)
            Positioned(
              left: 16,
              right: 16,
              bottom: 155,
              child: SafeArea(
                top: false,
                child: _readyCard(),
              ),
            ),

          // ====================================================
          // CAMERA CONTROLS
          // ====================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CameraControls(
              isDetecting: _detecting,
              isFlashOn: _flashOn,
              onStartDetection:
              _startDetection,
              onStopDetection:
              _stopDetection,
              onToggleFlash:
              _toggleFlash,
              onSwitchCamera:
              _switchCamera,
            ),
          ),

          // ====================================================
          // SWITCH CAMERA LOADING
          // ====================================================

          if (_switchingCamera)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child:
                  CircularProgressIndicator(
                    color:
                    Colors.greenAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // CAMERA PREVIEW
  // ============================================================

  Widget _cameraPreview(
      CameraController controller) {
    final Size? previewSize =
        controller.value.previewSize;

    if (previewSize == null) {
      return const Center(
        child:
        CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      );
    }

    /*
    Camera plugin can report dimensions
    according to sensor orientation.

    For portrait display:

        display width  = preview height
        display height = preview width
    */

    final double cameraWidth =
        previewSize.height;

    final double cameraHeight =
        previewSize.width;

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          child: SizedBox(
            width: cameraWidth,
            height: cameraHeight,
            child: CameraPreview(
              controller,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Row(
      children: [
        // ------------------------------------------------------
        // ICON
        // ------------------------------------------------------

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color:
            Colors.black.withOpacity(0.58),
            borderRadius:
            BorderRadius.circular(15),
            border: Border.all(
              color:
              Colors.white.withOpacity(
                0.14,
              ),
            ),
          ),
          child: const Icon(
            Icons.center_focus_strong_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------
        // TITLE
        // ------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Object Detection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 250,
                    ),
                    width: 8,
                    height: 8,
                    decoration:
                    BoxDecoration(
                      color: _detecting
                          ? Colors.greenAccent
                          : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    _detecting
                        ? 'Live detection active'
                        : 'Camera ready',
                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ------------------------------------------------------
        // ML KIT BADGE
        // ------------------------------------------------------

        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color:
            Colors.black.withOpacity(
              0.58,
            ),
            borderRadius:
            BorderRadius.circular(14),
            border: Border.all(
              color:
              Colors.white.withOpacity(
                0.14,
              ),
            ),
          ),
          child: const Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Icon(
                Icons.psychology_rounded,
                color:
                Colors.greenAccent,
                size: 17,
              ),
              SizedBox(width: 5),
              Text(
                'ML Kit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DETECTION BOXES
  // ============================================================

  List<Widget> _buildDetectionBoxes() {
    final CameraController? controller =
        _cameraService.cameraController;

    if (controller == null ||
        !controller.value.isInitialized) {
      return [];
    }

    final Size screenSize =
        MediaQuery.of(context).size;

    final Size? cameraPreviewSize =
        controller.value.previewSize;

    if (cameraPreviewSize == null) {
      return [];
    }

    if (screenSize.width <= 0 ||
        screenSize.height <= 0) {
      return [];
    }

    /*
    IMPORTANT:

    Keep this same orientation mapping
    because ML Kit image coordinates and
    CameraPreview coordinates are different.
    */

    final Size imageSize = Size(
      cameraPreviewSize.height,
      cameraPreviewSize.width,
    );

    if (imageSize.width <= 0 ||
        imageSize.height <= 0) {
      return [];
    }

    final CameraDescription? camera =
        _cameraService.currentCamera;

    if (camera == null) {
      return [];
    }

    final bool isFrontCamera =
        camera.lensDirection ==
            CameraLensDirection.front;

    return _detections.map(
          (DetectionResult detection) {
        return DetectionBox(
          boundingBox:
          detection.boundingBox,

          label:
          detection.label,

          confidence:
          detection.confidence,

          imageSize:
          imageSize,

          previewSize:
          screenSize,

          isFrontCamera:
          isFrontCamera,
        );
      },
    ).toList();
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _infoCard() {
    if (_detections.isEmpty) {
      return const SizedBox.shrink();
    }

    final DetectionResult best =
    _detections.reduce(
          (DetectionResult a,
          DetectionResult b) {
        return b.confidence >
            a.confidence
            ? b
            : a;
      },
    );

    return DetectionInfoCard(
      objectName: best.label,
      confidence:
      best.confidence,
      objectCount:
      _detections.length,
    );
  }

  // ============================================================
  // READY CARD
  // ============================================================

  Widget _readyCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
        Colors.black.withOpacity(0.74),
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color:
          Colors.white.withOpacity(
            0.13,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.25,
            ),
            blurRadius: 22,
            offset:
            const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.center_focus_strong_rounded,
            color: Colors.greenAccent,
            size: 29,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to detect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Press Start Detection and point your camera at an object.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCANNING INDICATOR
  // ============================================================

  Widget _scanningIndicator() {
    return Center(
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color:
          Colors.black.withOpacity(
            0.65,
          ),
          borderRadius:
          BorderRadius.circular(30),
          border: Border.all(
            color:
            Colors.greenAccent
                .withOpacity(0.28),
          ),
        ),
        child: const Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
                color:
                Colors.greenAccent,
              ),
            ),

            SizedBox(width: 9),

            Text(
              'Scanning objects...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOADING SCREEN
  // ============================================================

  Widget _loadingScreen() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 55,
            ),

            SizedBox(height: 18),

            Text(
              'Starting Camera...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: 30,
              height: 30,
              child:
              CircularProgressIndicator(
                strokeWidth: 2.5,
                color:
                Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR SCREEN
  // ============================================================

  Widget _errorScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.06),
                borderRadius:
                BorderRadius.circular(
                  26,
                ),
                border: Border.all(
                  color: Colors.redAccent
                      .withOpacity(0.20),
                ),
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration:
                    BoxDecoration(
                      color: Colors.redAccent
                          .withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons
                          .no_photography_outlined,
                      color:
                      Colors.redAccent,
                      size: 42,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Camera Unavailable',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _error ??
                        'Unable to access the camera.',
                    textAlign:
                    TextAlign.center,
                    style:
                    const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child:
                    ElevatedButton.icon(
                      onPressed: _initialize,
                      icon: const Icon(
                        Icons.refresh_rounded,
                      ),
                      label: const Text(
                        'Try Again',
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 15,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// import '../models/detection_result.dart';
// import '../services/object_detection_service.dart';
//
// class ObjectDetectionScreen extends StatefulWidget {
//   const ObjectDetectionScreen({super.key});
//
//   @override
//   State<ObjectDetectionScreen> createState() =>
//       _ObjectDetectionScreenState();
// }
//
// class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
//   // ============================================================
//   // COLORS
//   // ============================================================
//
//   static const Color darkGreen = Color(0xFF07110D);
//   static const Color darkCard = Color(0xFF10271E);
//   static const Color primaryGreen = Color(0xFF15966A);
//   static const Color mint = Color(0xFF6FF7BE);
//
//   // ============================================================
//   // CAMERA
//   // ============================================================
//
//   CameraController? _cameraController;
//
//   List<CameraDescription> _cameras = [];
//
//   int _currentCameraIndex = 0;
//
//   bool _isCameraReady = false;
//   bool _isInitializing = true;
//   bool _isFlashOn = false;
//
//   // ============================================================
//   // DETECTION
//   // ============================================================
//
//   late ObjectDetectionService _detectionService;
//
//   List<DetectionResult> _detections = [];
//
//   bool _isDetecting = false;
//
//   // UI update throttle.
//   DateTime _lastUiUpdate =
//   DateTime.fromMillisecondsSinceEpoch(0);
//
//   static const int _uiUpdateInterval = 70;
//
//   // ============================================================
//   // INIT
//   // ============================================================
//
//   @override
//   void initState() {
//     super.initState();
//
//     _detectionService = ObjectDetectionService();
//
//     _initializeCamera();
//   }
//
//   // ============================================================
//   // CAMERA INITIALIZATION
//   // ============================================================
//
//   Future<void> _initializeCamera() async {
//     try {
//       if (mounted) {
//         setState(() {
//           _isInitializing = true;
//         });
//       }
//
//       _cameras = await availableCameras();
//
//       if (_cameras.isEmpty) {
//         throw Exception('No camera found.');
//       }
//
//       // Prefer back camera.
//       int backCameraIndex = _cameras.indexWhere(
//             (camera) =>
//         camera.lensDirection == CameraLensDirection.back,
//       );
//
//       if (backCameraIndex == -1) {
//         backCameraIndex = 0;
//       }
//
//       _currentCameraIndex = backCameraIndex;
//
//       await _startCamera(
//         _cameras[_currentCameraIndex],
//       );
//     } catch (e) {
//       debugPrint(
//         'Camera initialization error: $e',
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         _isInitializing = false;
//         _isCameraReady = false;
//       });
//
//       _showError('Unable to start camera.');
//     }
//   }
//
//   // ============================================================
//   // START CAMERA
//   // ============================================================
//
//   Future<void> _startCamera(
//       CameraDescription camera,
//       ) async {
//     try {
//       // Stop previous camera.
//       await _stopCamera();
//
//       /*
//        * MEDIUM resolution is intentionally used.
//        *
//        * Very high resolution makes ML Kit slower.
//        * Medium gives a good balance between:
//        *
//        * - Camera quality
//        * - Detection speed
//        * - Device performance
//        * - Battery
//        */
//
//       final CameraController controller = CameraController(
//         camera,
//         ResolutionPreset.medium,
//         enableAudio: false,
//         imageFormatGroup: ImageFormatGroup.nv21,
//       );
//
//       _cameraController = controller;
//
//       await controller.initialize();
//
//       if (!mounted) return;
//
//       _isFlashOn = false;
//
//       try {
//         await controller.setFlashMode(
//           FlashMode.off,
//         );
//       } catch (e) {
//         debugPrint(
//           'Flash initialization error: $e',
//         );
//       }
//
//       // Start camera image stream.
//       await controller.startImageStream(
//         _processCameraFrame,
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         _isCameraReady = true;
//         _isInitializing = false;
//       });
//     } catch (e) {
//       debugPrint(
//         'Start camera error: $e',
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         _isCameraReady = false;
//         _isInitializing = false;
//       });
//
//       _showError(
//         'Camera could not be started.',
//       );
//     }
//   }
//
//   // ============================================================
//   // PROCESS CAMERA FRAME
//   // ============================================================
//
//   Future<void> _processCameraFrame(
//       CameraImage image,
//       ) async {
//     if (!mounted) return;
//
//     final CameraController? controller =
//         _cameraController;
//
//     if (controller == null ||
//         !controller.value.isInitialized) {
//       return;
//     }
//
//     // Don't process another frame while current
//     // ML Kit operation is running.
//     if (_isDetecting) {
//       return;
//     }
//
//     _isDetecting = true;
//
//     try {
//       final List<DetectionResult> results =
//       await _detectionService.processCameraImage(
//         image,
//         controller.description,
//       );
//
//       if (!mounted) return;
//
//       final DateTime now = DateTime.now();
//
//       final int difference =
//           now.difference(_lastUiUpdate).inMilliseconds;
//
//       if (difference < _uiUpdateInterval) {
//         return;
//       }
//
//       _lastUiUpdate = now;
//
//       setState(() {
//         _detections = results;
//       });
//     } catch (e) {
//       debugPrint(
//         'Frame processing error: $e',
//       );
//     } finally {
//       _isDetecting = false;
//     }
//   }
//
//   // ============================================================
//   // SWITCH CAMERA
//   // ============================================================
//
//   Future<void> _switchCamera() async {
//     if (_cameras.length < 2) {
//       _showMessage(
//         'Only one camera is available.',
//       );
//       return;
//     }
//
//     try {
//       if (mounted) {
//         setState(() {
//           _isCameraReady = false;
//           _detections = [];
//         });
//       }
//
//       _currentCameraIndex =
//           (_currentCameraIndex + 1) %
//               _cameras.length;
//
//       await _startCamera(
//         _cameras[_currentCameraIndex],
//       );
//     } catch (e) {
//       debugPrint(
//         'Camera switch error: $e',
//       );
//     }
//   }
//
//   // ============================================================
//   // FLASH
//   // ============================================================
//
//   Future<void> _toggleFlash() async {
//     final CameraController? controller =
//         _cameraController;
//
//     if (controller == null ||
//         !controller.value.isInitialized) {
//       return;
//     }
//
//     try {
//       final bool newFlashState = !_isFlashOn;
//
//       await controller.setFlashMode(
//         newFlashState
//             ? FlashMode.torch
//             : FlashMode.off,
//       );
//
//       if (mounted) {
//         setState(() {
//           _isFlashOn = newFlashState;
//         });
//       }
//     } catch (e) {
//       debugPrint(
//         'Flash error: $e',
//       );
//
//       _showMessage(
//         'Flash is not available.',
//       );
//     }
//   }
//
//   // ============================================================
//   // STOP CAMERA
//   // ============================================================
//
//   Future<void> _stopCamera() async {
//     final CameraController? controller =
//         _cameraController;
//
//     if (controller == null) {
//       return;
//     }
//
//     try {
//       if (controller.value.isStreamingImages) {
//         await controller.stopImageStream();
//       }
//     } catch (e) {
//       debugPrint(
//         'Stop image stream error: $e',
//       );
//     }
//
//     try {
//       await controller.dispose();
//     } catch (e) {
//       debugPrint(
//         'Camera dispose error: $e',
//       );
//     }
//
//     _cameraController = null;
//   }
//
//   // ============================================================
//   // ERROR MESSAGE
//   // ============================================================
//
//   void _showError(String message) {
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   // ============================================================
//   // NORMAL MESSAGE
//   // ============================================================
//
//   void _showMessage(String message) {
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
//
//   // ============================================================
//   // DISPOSE
//   // ============================================================
//
//   @override
//   void dispose() {
//     _detectionService.dispose();
//     _stopCamera();
//
//     super.dispose();
//   }
//
//   // ============================================================
//   // BUILD
//   // ============================================================
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: darkGreen,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildTopBar(),
//
//             Expanded(
//               child: _buildCameraArea(),
//             ),
//
//             _buildBottomPanel(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // TOP BAR
//   // ============================================================
//
//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         14,
//         10,
//         14,
//         10,
//       ),
//       child: Row(
//         children: [
//           _roundButton(
//             icon: Icons.arrow_back_rounded,
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//
//           const SizedBox(width: 12),
//
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Object Detection',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'Real-time AI vision',
//                   style: TextStyle(
//                     color: Colors.white54,
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           _roundButton(
//             icon: Icons.flash_on_rounded,
//             active: _isFlashOn,
//             onTap: _toggleFlash,
//           ),
//
//           const SizedBox(width: 8),
//
//           _roundButton(
//             icon: Icons.flip_camera_android_rounded,
//             onTap: _switchCamera,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // CAMERA AREA
//   // ============================================================
//
//   Widget _buildCameraArea() {
//     if (_isInitializing ||
//         !_isCameraReady ||
//         _cameraController == null) {
//       return _buildLoadingCamera();
//     }
//
//     final CameraController controller =
//     _cameraController!;
//
//     if (!controller.value.isInitialized) {
//       return _buildLoadingCamera();
//     }
//
//     final Size previewSize =
//         controller.value.previewSize ??
//             const Size(1280, 720);
//
//     return LayoutBuilder(
//       builder: (
//           BuildContext context,
//           BoxConstraints constraints,
//           ) {
//         return Container(
//           margin: const EdgeInsets.symmetric(
//             horizontal: 14,
//             vertical: 8,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(28),
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // ==================================================
//               // CAMERA PREVIEW
//               // ==================================================
//
//               Center(
//                 child: AspectRatio(
//                   aspectRatio:
//                   controller.value.aspectRatio,
//                   child: CameraPreview(
//                     controller,
//                   ),
//                 ),
//               ),
//
//               // ==================================================
//               // DETECTION BOXES
//               // ==================================================
//
//               Positioned.fill(
//                 child: CustomPaint(
//                   painter: DetectionBoxPainter(
//                     detections: _detections,
//                     imageSize: Size(
//                       previewSize.height,
//                       previewSize.width,
//                     ),
//                     isFrontCamera:
//                     controller.description.lensDirection ==
//                         CameraLensDirection.front,
//                   ),
//                 ),
//               ),
//
//               // ==================================================
//               // TOP STATUS
//               // ==================================================
//
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 right: 16,
//                 child: Row(
//                   children: [
//                     _liveBadge(),
//                     const Spacer(),
//                     if (_detections.isNotEmpty)
//                       _detectionCountBadge(),
//                   ],
//                 ),
//               ),
//
//               // ==================================================
//               // CENTER GUIDE
//               // ==================================================
//
//               if (_detections.isEmpty)
//                 const Center(
//                   child: _ScanGuide(),
//                 ),
//
//               // ==================================================
//               // BOTTOM HINT
//               // ==================================================
//
//               Positioned(
//                 bottom: 16,
//                 left: 16,
//                 right: 16,
//                 child: _cameraHint(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // ============================================================
//   // LOADING CAMERA
//   // ============================================================
//
//   Widget _buildLoadingCamera() {
//     return Container(
//       margin: const EdgeInsets.symmetric(
//         horizontal: 14,
//         vertical: 8,
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D1D16),
//         borderRadius: BorderRadius.circular(28),
//       ),
//       child: const Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 35,
//               height: 35,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.5,
//                 color: Color(0xFF6FF7BE),
//               ),
//             ),
//             SizedBox(height: 15),
//             Text(
//               'Starting camera...',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // LIVE BADGE
//   // ============================================================
//
//   Widget _liveBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 11,
//         vertical: 7,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.55),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: mint.withOpacity(0.25),
//         ),
//       ),
//       child: const Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.circle,
//             color: Color(0xFF6FF7BE),
//             size: 7,
//           ),
//           SizedBox(width: 6),
//           Text(
//             'LIVE AI',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 9,
//               fontWeight: FontWeight.w900,
//               letterSpacing: 0.8,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // DETECTION COUNT
//   // ============================================================
//
//   Widget _detectionCountBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 11,
//         vertical: 7,
//       ),
//       decoration: BoxDecoration(
//         color: darkGreen.withOpacity(0.85),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.visibility_rounded,
//             color: mint,
//             size: 14,
//           ),
//           const SizedBox(width: 5),
//           Text(
//             '${_detections.length} detected',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 10,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // CAMERA HINT
//   // ============================================================
//
//   Widget _cameraHint() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 14,
//         vertical: 11,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.60),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.lightbulb_outline_rounded,
//             color: mint,
//             size: 17,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               _detections.isEmpty
//                   ? 'Move the camera slowly over an object.'
//                   : 'Object detected — keep it inside the frame.',
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 10,
//                 height: 1.3,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // BOTTOM PANEL
//   // ============================================================
//
//   Widget _buildBottomPanel() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(
//         16,
//         14,
//         16,
//         12,
//       ),
//       decoration: const BoxDecoration(
//         color: darkGreen,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(
//                 Icons.auto_awesome_rounded,
//                 color: mint,
//                 size: 18,
//               ),
//               const SizedBox(width: 7),
//               const Text(
//                 'Detection Results',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 _detections.isEmpty
//                     ? 'Scanning...'
//                     : '${_detections.length} object(s)',
//                 style: const TextStyle(
//                   color: Colors.white54,
//                   fontSize: 10,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//           if (_detections.isEmpty)
//             _emptyResult()
//           else
//             _resultList(),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // EMPTY RESULT
//   // ============================================================
//
//   Widget _emptyResult() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 14,
//         vertical: 12,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.045),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: const Row(
//         children: [
//           Icon(
//             Icons.search_rounded,
//             color: Colors.white38,
//             size: 18,
//           ),
//           SizedBox(width: 9),
//           Expanded(
//             child: Text(
//               'Looking for objects...',
//               style: TextStyle(
//                 color: Colors.white54,
//                 fontSize: 11,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 15,
//             height: 15,
//             child: CircularProgressIndicator(
//               strokeWidth: 1.8,
//               color: mint,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // RESULT LIST
//   // ============================================================
//
//   Widget _resultList() {
//     return SizedBox(
//       height: 62,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: _detections.length,
//         separatorBuilder: (_, __) =>
//         const SizedBox(width: 9),
//         itemBuilder: (context, index) {
//           final DetectionResult result =
//           _detections[index];
//
//           return _resultCard(result);
//         },
//       ),
//     );
//   }
//
//   // ============================================================
//   // RESULT CARD
//   // ============================================================
//
//   Widget _resultCard(
//       DetectionResult result,
//       ) {
//     final int confidence =
//     (result.confidence * 100)
//         .round()
//         .clamp(0, 100);
//
//     return Container(
//       width: 155,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 9,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.06),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: mint.withOpacity(0.12),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: mint.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(11),
//             ),
//             child: const Icon(
//               Icons.visibility_rounded,
//               color: mint,
//               size: 18,
//             ),
//           ),
//
//           const SizedBox(width: 8),
//
//           Expanded(
//             child: Column(
//               mainAxisAlignment:
//               MainAxisAlignment.center,
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   result.label,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//
//                 const SizedBox(height: 3),
//
//                 Text(
//                   '$confidence% confidence',
//                   style: const TextStyle(
//                     color: Colors.white54,
//                     fontSize: 9,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // ROUND BUTTON
//   // ============================================================
//
//   Widget _roundButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     bool active = false,
//   }) {
//     return Material(
//       color: active
//           ? mint.withOpacity(0.15)
//           : Colors.white.withOpacity(0.07),
//       borderRadius: BorderRadius.circular(15),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           width: 43,
//           height: 43,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: active
//                   ? mint.withOpacity(0.35)
//                   : Colors.white.withOpacity(0.08),
//             ),
//           ),
//           child: Icon(
//             icon,
//             color: active ? mint : Colors.white,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // =================================================================
// // SCAN GUIDE
// // =================================================================
//
// class _ScanGuide extends StatelessWidget {
//   const _ScanGuide();
//
//   // Local color constant.
//   static const Color guideMint =
//   Color(0xFF6FF7BE);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 115,
//           height: 115,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(
//               color: guideMint.withOpacity(0.55),
//               width: 1.5,
//             ),
//           ),
//           child: const Center(
//             child: Icon(
//               Icons.center_focus_strong_rounded,
//               color: guideMint,
//               size: 42,
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 16),
//
//         Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 14,
//             vertical: 8,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.55),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: const Text(
//             'Point at an object',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // =================================================================
// // DETECTION BOX PAINTER
// // =================================================================
//
// class DetectionBoxPainter extends CustomPainter {
//   final List<DetectionResult> detections;
//   final Size imageSize;
//   final bool isFrontCamera;
//
//   // Local color constant.
//   static const Color painterMint =
//   Color(0xFF6FF7BE);
//
//   DetectionBoxPainter({
//     required this.detections,
//     required this.imageSize,
//     required this.isFrontCamera,
//   });
//
//   @override
//   void paint(
//       Canvas canvas,
//       Size size,
//       ) {
//     if (detections.isEmpty) {
//       return;
//     }
//
//     if (imageSize.width <= 0 ||
//         imageSize.height <= 0) {
//       return;
//     }
//
//     final double scaleX =
//         size.width / imageSize.width;
//
//     final double scaleY =
//         size.height / imageSize.height;
//
//     for (final DetectionResult detection
//     in detections) {
//       final Rect box =
//           detection.boundingBox;
//
//       double left =
//           box.left * scaleX;
//
//       double top =
//           box.top * scaleY;
//
//       double right =
//           box.right * scaleX;
//
//       double bottom =
//           box.bottom * scaleY;
//
//       // ========================================================
//       // FRONT CAMERA MIRROR
//       // ========================================================
//
//       if (isFrontCamera) {
//         final double mirroredLeft =
//             size.width - right;
//
//         final double mirroredRight =
//             size.width - left;
//
//         left = mirroredLeft;
//         right = mirroredRight;
//       }
//
//       final Rect rect = Rect.fromLTRB(
//         left,
//         top,
//         right,
//         bottom,
//       );
//
//       // ========================================================
//       // GLOW
//       // ========================================================
//
//       final Paint glowPaint = Paint()
//         ..color = painterMint.withOpacity(0.18)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 7
//         ..maskFilter = const MaskFilter.blur(
//           BlurStyle.normal,
//           6,
//         );
//
//       canvas.drawRect(
//         rect,
//         glowPaint,
//       );
//
//       // ========================================================
//       // MAIN BOX
//       // ========================================================
//
//       final Paint boxPaint = Paint()
//         ..color = painterMint
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2;
//
//       canvas.drawRect(
//         rect,
//         boxPaint,
//       );
//
//       // ========================================================
//       // CORNERS
//       // ========================================================
//
//       final Paint cornerPaint = Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 3;
//
//       const double cornerLength = 12;
//
//       // --------------------------------------------------------
//       // TOP LEFT
//       // --------------------------------------------------------
//
//       canvas.drawLine(
//         Offset(
//           rect.left,
//           rect.top,
//         ),
//         Offset(
//           rect.left + cornerLength,
//           rect.top,
//         ),
//         cornerPaint,
//       );
//
//       canvas.drawLine(
//         Offset(
//           rect.left,
//           rect.top,
//         ),
//         Offset(
//           rect.left,
//           rect.top + cornerLength,
//         ),
//         cornerPaint,
//       );
//
//       // --------------------------------------------------------
//       // TOP RIGHT
//       // --------------------------------------------------------
//
//       canvas.drawLine(
//         Offset(
//           rect.right,
//           rect.top,
//         ),
//         Offset(
//           rect.right - cornerLength,
//           rect.top,
//         ),
//         cornerPaint,
//       );
//
//       canvas.drawLine(
//         Offset(
//           rect.right,
//           rect.top,
//         ),
//         Offset(
//           rect.right,
//           rect.top + cornerLength,
//         ),
//         cornerPaint,
//       );
//
//       // --------------------------------------------------------
//       // BOTTOM LEFT
//       // --------------------------------------------------------
//
//       canvas.drawLine(
//         Offset(
//           rect.left,
//           rect.bottom,
//         ),
//         Offset(
//           rect.left + cornerLength,
//           rect.bottom,
//         ),
//         cornerPaint,
//       );
//
//       canvas.drawLine(
//         Offset(
//           rect.left,
//           rect.bottom,
//         ),
//         Offset(
//           rect.left,
//           rect.bottom - cornerLength,
//         ),
//         cornerPaint,
//       );
//
//       // --------------------------------------------------------
//       // BOTTOM RIGHT
//       // --------------------------------------------------------
//
//       canvas.drawLine(
//         Offset(
//           rect.right,
//           rect.bottom,
//         ),
//         Offset(
//           rect.right - cornerLength,
//           rect.bottom,
//         ),
//         cornerPaint,
//       );
//
//       canvas.drawLine(
//         Offset(
//           rect.right,
//           rect.bottom,
//         ),
//         Offset(
//           rect.right,
//           rect.bottom - cornerLength,
//         ),
//         cornerPaint,
//       );
//
//       // ========================================================
//       // LABEL
//       // ========================================================
//
//       final int confidence =
//       (detection.confidence * 100)
//           .round()
//           .clamp(0, 100);
//
//       final String label =
//           '${detection.label}  $confidence%';
//
//       final TextPainter textPainter =
//       TextPainter(
//         text: TextSpan(
//           text: label,
//           style: const TextStyle(
//             color: Color(0xFF07110D),
//             fontSize: 11,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );
//
//       textPainter.layout(
//         maxWidth: size.width - 20,
//       );
//
//       final double labelWidth =
//           textPainter.width + 16;
//
//       const double labelHeight = 25;
//
//       double labelLeft = rect.left;
//
//       double labelTop =
//           rect.top - labelHeight - 4;
//
//       // Keep label horizontally inside screen.
//       if (labelLeft < 4) {
//         labelLeft = 4;
//       }
//
//       if (labelLeft + labelWidth >
//           size.width - 4) {
//         labelLeft =
//             size.width -
//                 labelWidth -
//                 4;
//       }
//
//       // Keep label vertically inside screen.
//       if (labelTop < 4) {
//         labelTop = rect.top + 4;
//       }
//
//       final RRect labelRect =
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(
//           labelLeft,
//           labelTop,
//           labelWidth,
//           labelHeight,
//         ),
//         const Radius.circular(8),
//       );
//
//       // ========================================================
//       // FIXED PAINT SYNTAX
//       // ========================================================
//
//       final Paint labelPaint = Paint()
//         ..color = painterMint
//         ..style = PaintingStyle.fill;
//
//       canvas.drawRRect(
//         labelRect,
//         labelPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           labelLeft + 8,
//           labelTop + 6,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(
//       covariant DetectionBoxPainter oldDelegate,
//       ) {
//     return oldDelegate.detections != detections ||
//         oldDelegate.imageSize != imageSize ||
//         oldDelegate.isFrontCamera != isFrontCamera;
//   }
// }