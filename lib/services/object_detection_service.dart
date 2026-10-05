// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
//
// import '../models/detection_result.dart';
//
// class ObjectDetectionService {
//   late final ObjectDetector _objectDetector;
//
//   // Prevent multiple frames from being processed
//   // simultaneously.
//   bool _isProcessing = false;
//
//   // ============================================================
//   // CONSTRUCTOR
//   // ============================================================
//
//   ObjectDetectionService() {
//     _objectDetector = ObjectDetector(
//       options: ObjectDetectorOptions(
//         mode: DetectionMode.stream,
//         classifyObjects: true,
//         multipleObjects: true,
//       ),
//     );
//   }
//
//   // ============================================================
//   // PROCESS CAMERA IMAGE
//   // ============================================================
//
//   Future<List<DetectionResult>> processCameraImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) async {
//     // If previous frame is still being processed,
//     // skip this frame.
//     if (_isProcessing) {
//       return [];
//     }
//
//     _isProcessing = true;
//
//     try {
//       final InputImage? inputImage =
//       _convertCameraImage(
//         image,
//         camera,
//       );
//
//       if (inputImage == null) {
//         return [];
//       }
//
//       // Send image to Google ML Kit
//       final List<DetectedObject> objects =
//       await _objectDetector.processImage(
//         inputImage,
//       );
//
//       final List<DetectionResult> results = [];
//
//       for (final DetectedObject object in objects) {
//         String label = 'Unknown object';
//         double confidence = 0.0;
//
//         // ML Kit may return multiple labels.
//         // Select the label with highest confidence.
//         if (object.labels.isNotEmpty) {
//           final Label bestLabel =
//           object.labels.reduce(
//                 (Label a, Label b) {
//               return a.confidence >
//                   b.confidence
//                   ? a
//                   : b;
//             },
//           );
//
//           label = bestLabel.text;
//           confidence = bestLabel.confidence;
//         }
//
//         results.add(
//           DetectionResult(
//             boundingBox: object.boundingBox,
//             label: label,
//             confidence: confidence,
//             trackingId: object.trackingId,
//           ),
//         );
//       }
//
//       return results;
//     } catch (e, stackTrace) {
//       debugPrint(
//         '========================================',
//       );
//
//       debugPrint(
//         'ML KIT OBJECT DETECTION ERROR',
//       );
//
//       debugPrint(
//         '$e',
//       );
//
//       debugPrint(
//         '$stackTrace',
//       );
//
//       debugPrint(
//         '========================================',
//       );
//
//       return [];
//     } finally {
//       _isProcessing = false;
//     }
//   }
//
//   // ============================================================
//   // CAMERA IMAGE → INPUT IMAGE
//   // ============================================================
//
//   InputImage? _convertCameraImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) {
//     try {
//       if (Platform.isAndroid) {
//         return _convertAndroidImage(
//           image,
//           camera,
//         );
//       }
//
//       if (Platform.isIOS) {
//         return _convertIOSImage(
//           image,
//           camera,
//         );
//       }
//
//       debugPrint(
//         'Object detection is supported only on Android/iOS.',
//       );
//
//       return null;
//     } catch (e) {
//       debugPrint(
//         'Camera image conversion error: $e',
//       );
//
//       return null;
//     }
//   }
//
//   // ============================================================
//   // ANDROID IMAGE CONVERSION
//   // ============================================================
//
//   InputImage? _convertAndroidImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) {
//     // Android camera normally gives YUV420
//     // with three planes.
//     if (image.planes.length != 3) {
//       debugPrint(
//         'Invalid Android image planes: '
//             '${image.planes.length}',
//       );
//
//       return null;
//     }
//
//     final Uint8List nv21Bytes =
//     _convertYUV420ToNV21(image);
//
//     if (nv21Bytes.isEmpty) {
//       return null;
//     }
//
//     final InputImageRotation rotation =
//     _getRotation(camera);
//
//     final InputImageMetadata metadata =
//     InputImageMetadata(
//       size: Size(
//         image.width.toDouble(),
//         image.height.toDouble(),
//       ),
//
//       rotation: rotation,
//
//       format: InputImageFormat.nv21,
//
//       bytesPerRow: image.width,
//     );
//
//     return InputImage.fromBytes(
//       bytes: nv21Bytes,
//       metadata: metadata,
//     );
//   }
//
//   // ============================================================
//   // YUV420 → NV21
//   // ============================================================
//
//   Uint8List _convertYUV420ToNV21(
//       CameraImage image,
//       ) {
//     final int width = image.width;
//     final int height = image.height;
//
//     final Plane yPlane =
//     image.planes[0];
//
//     final Plane uPlane =
//     image.planes[1];
//
//     final Plane vPlane =
//     image.planes[2];
//
//     // NV21 size = Y + VU
//     final int ySize =
//         width * height;
//
//     final int uvSize =
//         width * height ~/ 2;
//
//     final Uint8List nv21 =
//     Uint8List(
//       ySize + uvSize,
//     );
//
//     int outputIndex = 0;
//
//     // ----------------------------------------------------------
//     // Y PLANE
//     // ----------------------------------------------------------
//
//     for (int row = 0;
//     row < height;
//     row++) {
//       final int rowStart =
//           row * yPlane.bytesPerRow;
//
//       for (int col = 0;
//       col < width;
//       col++) {
//         final int index =
//             rowStart + col;
//
//         if (index <
//             yPlane.bytes.length) {
//           nv21[outputIndex++] =
//           yPlane.bytes[index];
//         }
//       }
//     }
//
//     // ----------------------------------------------------------
//     // VU PLANE
//     // ----------------------------------------------------------
//
//     final int uvWidth =
//         width ~/ 2;
//
//     final int uvHeight =
//         height ~/ 2;
//
//     final int uPixelStride =
//         uPlane.bytesPerPixel ?? 1;
//
//     final int vPixelStride =
//         vPlane.bytesPerPixel ?? 1;
//
//     for (int row = 0;
//     row < uvHeight;
//     row++) {
//       final int uRowStart =
//           row * uPlane.bytesPerRow;
//
//       final int vRowStart =
//           row * vPlane.bytesPerRow;
//
//       for (int col = 0;
//       col < uvWidth;
//       col++) {
//         final int uIndex =
//             uRowStart +
//                 col * uPixelStride;
//
//         final int vIndex =
//             vRowStart +
//                 col * vPixelStride;
//
//         if (vIndex <
//             vPlane.bytes.length &&
//             uIndex <
//                 uPlane.bytes.length) {
//           // NV21 = V then U
//           nv21[outputIndex++] =
//           vPlane.bytes[vIndex];
//
//           nv21[outputIndex++] =
//           uPlane.bytes[uIndex];
//         }
//       }
//     }
//
//     return nv21;
//   }
//
//   // ============================================================
//   // IOS IMAGE CONVERSION
//   // ============================================================
//
//   InputImage? _convertIOSImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) {
//     // iOS camera should normally provide
//     // BGRA8888 as one plane.
//     if (image.planes.length != 1) {
//       debugPrint(
//         'Invalid iOS image planes: '
//             '${image.planes.length}',
//       );
//
//       return null;
//     }
//
//     final Plane plane =
//         image.planes.first;
//
//     final InputImageMetadata metadata =
//     InputImageMetadata(
//       size: Size(
//         image.width.toDouble(),
//         image.height.toDouble(),
//       ),
//
//       rotation: _getRotation(camera),
//
//       format:
//       InputImageFormat.bgra8888,
//
//       bytesPerRow:
//       plane.bytesPerRow,
//     );
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: metadata,
//     );
//   }
//
//   // ============================================================
//   // CAMERA ROTATION
//   // ============================================================
//
//   InputImageRotation _getRotation(
//       CameraDescription camera,
//       ) {
//     switch (camera.sensorOrientation) {
//       case 90:
//         return InputImageRotation
//             .rotation90deg;
//
//       case 180:
//         return InputImageRotation
//             .rotation180deg;
//
//       case 270:
//         return InputImageRotation
//             .rotation270deg;
//
//       case 0:
//         return InputImageRotation
//             .rotation0deg;
//
//       default:
//         return InputImageRotation
//             .rotation0deg;
//     }
//   }
//
//   // ============================================================
//   // DISPOSE
//   // ============================================================
//
//   Future<void> dispose() async {
//     await _objectDetector.close();
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
//
// import '../models/detection_result.dart';
//
// class ObjectDetectionService {
//   late final ObjectDetector _objectDetector;
//
//   // ============================================================
//   // PROCESSING CONTROL
//   // ============================================================
//
//   bool _isProcessing = false;
//
//   // Keep the last valid detection for a short time.
//   // This prevents boxes from disappearing between frames.
//   List<DetectionResult> _lastResults = [];
//
//   DateTime? _lastDetectionTime;
//
//   // How long the previous detection can remain visible
//   // when ML Kit temporarily returns no object.
//   static const Duration _detectionHoldDuration =
//   Duration(milliseconds: 500);
//
//   // Ignore very weak detections.
//   static const double _minimumConfidence = 0.35;
//
//   // ============================================================
//   // CONSTRUCTOR
//   // ============================================================
//
//   ObjectDetectionService() {
//     _objectDetector = ObjectDetector(
//       options: ObjectDetectorOptions(
//         mode: DetectionMode.stream,
//         classifyObjects: true,
//         multipleObjects: true,
//       ),
//     );
//   }
//
//   // ============================================================
//   // PROCESS CAMERA IMAGE
//   // ============================================================
//
//   Future<List<DetectionResult>> processCameraImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) async {
//     // ----------------------------------------------------------
//     // IMPORTANT:
//     // If another frame is currently being processed,
//     // don't clear the previous detection.
//     // ----------------------------------------------------------
//
//     if (_isProcessing) {
//       return _lastResults;
//     }
//
//     _isProcessing = true;
//
//     try {
//       final InputImage? inputImage =
//       _convertCameraImage(
//         image,
//         camera,
//       );
//
//       if (inputImage == null) {
//         return _keepPreviousDetection();
//       }
//
//       // --------------------------------------------------------
//       // RUN GOOGLE ML KIT
//       // --------------------------------------------------------
//
//       final List<DetectedObject> objects =
//       await _objectDetector.processImage(
//         inputImage,
//       );
//
//       // --------------------------------------------------------
//       // NO OBJECT DETECTED
//       // --------------------------------------------------------
//
//       if (objects.isEmpty) {
//         return _keepPreviousDetection();
//       }
//
//       final List<DetectionResult> results = [];
//
//       // --------------------------------------------------------
//       // CONVERT ML KIT OBJECTS
//       // --------------------------------------------------------
//
//       for (final DetectedObject object in objects) {
//         String label = 'Unknown object';
//         double confidence = 0.0;
//
//         // ------------------------------------------------------
//         // GET BEST CLASSIFICATION LABEL
//         // ------------------------------------------------------
//
//         if (object.labels.isNotEmpty) {
//           final Label bestLabel =
//           object.labels.reduce(
//                 (Label a, Label b) {
//               return a.confidence >= b.confidence
//                   ? a
//                   : b;
//             },
//           );
//
//           label = _cleanLabel(bestLabel.text);
//           confidence = bestLabel.confidence;
//         }
//
//         // ------------------------------------------------------
//         // CONFIDENCE FILTER
//         // ------------------------------------------------------
//
//         if (confidence < _minimumConfidence) {
//           continue;
//         }
//
//         // ------------------------------------------------------
//         // CREATE RESULT
//         // ------------------------------------------------------
//
//         results.add(
//           DetectionResult(
//             boundingBox: object.boundingBox,
//             label: label,
//             confidence: confidence,
//             trackingId: object.trackingId,
//           ),
//         );
//       }
//
//       // --------------------------------------------------------
//       // ALL DETECTIONS WERE TOO WEAK
//       // --------------------------------------------------------
//
//       if (results.isEmpty) {
//         return _keepPreviousDetection();
//       }
//
//       // --------------------------------------------------------
//       // SAVE VALID RESULT
//       // --------------------------------------------------------
//
//       _lastResults = results;
//       _lastDetectionTime = DateTime.now();
//
//       return results;
//     } catch (e, stackTrace) {
//       debugPrint(
//         '========================================',
//       );
//
//       debugPrint(
//         'ML KIT OBJECT DETECTION ERROR',
//       );
//
//       debugPrint('$e');
//       debugPrint('$stackTrace');
//
//       debugPrint(
//         '========================================',
//       );
//
//       return _keepPreviousDetection();
//     } finally {
//       _isProcessing = false;
//     }
//   }
//
//   // ============================================================
//   // KEEP PREVIOUS DETECTION
//   // ============================================================
//
//   List<DetectionResult> _keepPreviousDetection() {
//     if (_lastDetectionTime == null ||
//         _lastResults.isEmpty) {
//       return [];
//     }
//
//     final Duration difference =
//     DateTime.now().difference(
//       _lastDetectionTime!,
//     );
//
//     // Keep old detection only for a short period.
//     if (difference <= _detectionHoldDuration) {
//       return _lastResults;
//     }
//
//     // Detection has been gone long enough.
//     _lastResults = [];
//     _lastDetectionTime = null;
//
//     return [];
//   }
//
//   // ============================================================
//   // CLEAN ML KIT LABEL
//   // ============================================================
//
//   String _cleanLabel(String originalLabel) {
//     final String label =
//     originalLabel.trim().toLowerCase();
//
//     // ----------------------------------------------------------
//     // ML Kit broad categories
//     // ----------------------------------------------------------
//
//     switch (label) {
//       case 'home good':
//         return 'Home Item';
//
//       case 'fashion good':
//         return 'Fashion Item';
//
//       case 'food':
//         return 'Food';
//
//       case 'plant':
//         return 'Plant';
//
//       default:
//       // Convert first letter to uppercase.
//         if (label.isEmpty) {
//           return 'Unknown object';
//         }
//
//         return label[0].toUpperCase() +
//             label.substring(1);
//     }
//   }
//
//   // ============================================================
//   // CAMERA IMAGE → INPUT IMAGE
//   // ============================================================
//
//   InputImage? _convertCameraImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) {
//     try {
//       if (Platform.isAndroid) {
//         return _convertAndroidImage(
//           image,
//           camera,
//         );
//       }
//
//       if (Platform.isIOS) {
//         return _convertIOSImage(
//           image,
//           camera,
//         );
//       }
//
//       debugPrint(
//         'Object detection is supported only on Android/iOS.',
//       );
//
//       return null;
//     } catch (e) {
//       debugPrint(
//         'Camera image conversion error: $e',
//       );
//
//       return null;
//     }
//   }
//
//   // ============================================================
//   // ANDROID IMAGE CONVERSION
//   // ============================================================
//
//   InputImage? _convertAndroidImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) {
//     // Android normally provides YUV420.
//     if (image.planes.length != 3) {
//       debugPrint(
//         'Invalid Android image planes: '
//             '${image.planes.length}',
//       );
//
//       return null;
//     }
//
//     final Uint8List nv21Bytes =
//     _convertYUV420ToNV21(image);
//
//     if (nv21Bytes.isEmpty) {
//       return null;
//     }
//
//     final InputImageRotation rotation =
//     _getRotation(camera);
//
//     final InputImageMetadata metadata =
//     InputImageMetadata(
//       size: Size(
//         image.width.toDouble(),
//         image.height.toDouble(),
//       ),
//       rotation: rotation,
//       format: InputImageFormat.nv21,
//       bytesPerRow: image.width,
//     );
//
//     return InputImage.fromBytes(
//       bytes: nv21Bytes,
//       metadata: metadata,
//     );
//   }
//
//   // ============================================================
//   // YUV420 → NV21
//   // ============================================================
//
//   Uint8List _convertYUV420ToNV21(
//       CameraImage image,
//       ) {
//     final int width = image.width;
//     final int height = image.height;
//
//     final Plane yPlane =
//     image.planes[0];
//
//     final Plane uPlane =
//     image.planes[1];
//
//     final Plane vPlane =
//     image.planes[2];
//
//     // NV21 = Y + VU
//     final int ySize =
//         width * height;
//
//     final int uvSize =
//         width * height ~/ 2;
//
//     final Uint8List nv21 =
//     Uint8List(
//       ySize + uvSize,
//     );
//
//     int outputIndex = 0;
//
//     // ==========================================================
//     // Y PLANE
//     // ==========================================================
//
//     for (int row = 0;
//     row < height;
//     row++) {
//       final int rowStart =
//           row * yPlane.bytesPerRow;
//
//       for (int col = 0;
//       col < width;
//       col++) {
//         final int index =
//             rowStart + col;
//
//         if (index <
//             yPlane.bytes.length) {
//           nv21[outputIndex++] =
//           yPlane.bytes[index];
//         }
//       }
//     }
//
//     // ==========================================================
//     // VU PLANE
//     // ==========================================================
//
//     final int uvWidth =
//         width ~/ 2;
//
//     final int uvHeight =
//         height ~/ 2;
//
//     final int uPixelStride =
//         uPlane.bytesPerPixel ?? 1;
//
//     final int vPixelStride =
//         vPlane.bytesPerPixel ?? 1;
//
//     for (int row = 0;
//     row < uvHeight;
//     row++) {
//       final int uRowStart =
//           row * uPlane.bytesPerRow;
//
//       final int vRowStart =
//           row * vPlane.bytesPerRow;
//
//       for (int col = 0;
//       col < uvWidth;
//       col++) {
//         final int uIndex =
//             uRowStart +
//                 col * uPixelStride;
//
//         final int vIndex =
//             vRowStart +
//                 col * vPixelStride;
//
//         if (vIndex <
//             vPlane.bytes.length &&
//             uIndex <
//                 uPlane.bytes.length) {
//           // NV21 = V + U
//           nv21[outputIndex++] =
//           vPlane.bytes[vIndex];
//
//           nv21[outputIndex++] =
//           uPlane.bytes[uIndex];
//         }
//       }
//     }
//
//     return nv21;
//   }
//
//   // ============================================================
//   // IOS IMAGE CONVERSION
//   // ============================================================
//
//   InputImage? _convertIOSImage(
//       CameraImage image,
//       CameraDescription camera,
//       ) {
//     if (image.planes.length != 1) {
//       debugPrint(
//         'Invalid iOS image planes: '
//             '${image.planes.length}',
//       );
//
//       return null;
//     }
//
//     final Plane plane =
//         image.planes.first;
//
//     final InputImageMetadata metadata =
//     InputImageMetadata(
//       size: Size(
//         image.width.toDouble(),
//         image.height.toDouble(),
//       ),
//       rotation: _getRotation(camera),
//       format: InputImageFormat.bgra8888,
//       bytesPerRow: plane.bytesPerRow,
//     );
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: metadata,
//     );
//   }
//
//   // ============================================================
//   // CAMERA ROTATION
//   // ============================================================
//
//   InputImageRotation _getRotation(
//       CameraDescription camera,
//       ) {
//     switch (camera.sensorOrientation) {
//       case 90:
//         return InputImageRotation.rotation90deg;
//
//       case 180:
//         return InputImageRotation.rotation180deg;
//
//       case 270:
//         return InputImageRotation.rotation270deg;
//
//       case 0:
//         return InputImageRotation.rotation0deg;
//
//       default:
//         return InputImageRotation.rotation0deg;
//     }
//   }
//
//   // ============================================================
//   // DISPOSE
//   // ============================================================
//
//   Future<void> dispose() async {
//     _lastResults = [];
//     _lastDetectionTime = null;
//
//     await _objectDetector.close();
//   }
// }


import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../models/detection_result.dart';

class ObjectDetectionService {
  late final ObjectDetector _objectDetector;

  // ============================================================
  // PROCESSING CONTROL
  // ============================================================

  bool _isProcessing = false;

  // Keep the last valid detection for a short time.
  // This prevents boxes from disappearing between frames.
  List<DetectionResult> _lastResults = [];

  DateTime? _lastDetectionTime;

  // How long the previous detection can remain visible
  // when ML Kit temporarily returns no object.
  static const Duration _detectionHoldDuration =
  Duration(milliseconds: 500);

  // Ignore very weak detections.
  static const double _minimumConfidence = 0.35;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  ObjectDetectionService() {
    _objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.stream,
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
  }

  // ============================================================
  // PROCESS CAMERA IMAGE
  // ============================================================

  Future<List<DetectionResult>> processCameraImage(
      CameraImage image,
      CameraDescription camera,
      ) async {
    // ----------------------------------------------------------
    // IMPORTANT:
    // If another frame is currently being processed,
    // don't clear the previous detection.
    // ----------------------------------------------------------

    if (_isProcessing) {
      return _lastResults;
    }

    _isProcessing = true;

    try {
      final InputImage? inputImage =
      _convertCameraImage(
        image,
        camera,
      );

      if (inputImage == null) {
        return _keepPreviousDetection();
      }

      // --------------------------------------------------------
      // RUN GOOGLE ML KIT
      // --------------------------------------------------------

      final List<DetectedObject> objects =
      await _objectDetector.processImage(
        inputImage,
      );

      // --------------------------------------------------------
      // NO OBJECT DETECTED
      // --------------------------------------------------------

      if (objects.isEmpty) {
        return _keepPreviousDetection();
      }

      final List<DetectionResult> results = [];

      // --------------------------------------------------------
      // CONVERT ML KIT OBJECTS
      // --------------------------------------------------------

      for (final DetectedObject object in objects) {
        String label = 'Unknown object';
        double confidence = 0.0;

        // ------------------------------------------------------
        // GET BEST CLASSIFICATION LABEL
        // ------------------------------------------------------

        if (object.labels.isNotEmpty) {
          final Label bestLabel =
          object.labels.reduce(
                (Label a, Label b) {
              return a.confidence >= b.confidence
                  ? a
                  : b;
            },
          );

          label = _cleanLabel(bestLabel.text);
          confidence = bestLabel.confidence;
        }

        // ------------------------------------------------------
        // CONFIDENCE FILTER
        // ------------------------------------------------------

        if (confidence < _minimumConfidence) {
          continue;
        }

        // ------------------------------------------------------
        // CREATE RESULT
        // ------------------------------------------------------

        results.add(
          DetectionResult(
            boundingBox: object.boundingBox,
            label: label,
            confidence: confidence,
            trackingId: object.trackingId,
          ),
        );
      }

      // --------------------------------------------------------
      // ALL DETECTIONS WERE TOO WEAK
      // --------------------------------------------------------

      if (results.isEmpty) {
        return _keepPreviousDetection();
      }

      // --------------------------------------------------------
      // SAVE VALID RESULT
      // --------------------------------------------------------

      _lastResults = results;
      _lastDetectionTime = DateTime.now();

      return results;
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'ML KIT OBJECT DETECTION ERROR',
      );

      debugPrint('$e');
      debugPrint('$stackTrace');

      debugPrint(
        '========================================',
      );

      return _keepPreviousDetection();
    } finally {
      _isProcessing = false;
    }
  }

  // ============================================================
  // KEEP PREVIOUS DETECTION
  // ============================================================

  List<DetectionResult> _keepPreviousDetection() {
    if (_lastDetectionTime == null ||
        _lastResults.isEmpty) {
      return [];
    }

    final Duration difference =
    DateTime.now().difference(
      _lastDetectionTime!,
    );

    // Keep old detection only for a short period.
    if (difference <= _detectionHoldDuration) {
      return _lastResults;
    }

    // Detection has been gone long enough.
    _lastResults = [];
    _lastDetectionTime = null;

    return [];
  }

  // ============================================================
  // CLEAN ML KIT LABEL
  // ============================================================

  String _cleanLabel(String originalLabel) {
    final String label =
    originalLabel.trim().toLowerCase();

    // ----------------------------------------------------------
    // ML Kit broad categories
    // ----------------------------------------------------------

    switch (label) {
      case 'home good':
        return 'Home Item';

      case 'fashion good':
        return 'Fashion Item';

      case 'food':
        return 'Food';

      case 'plant':
        return 'Plant';

      default:
      // Convert first letter to uppercase.
        if (label.isEmpty) {
          return 'Unknown object';
        }

        return label[0].toUpperCase() +
            label.substring(1);
    }
  }

  // ============================================================
  // CAMERA IMAGE → INPUT IMAGE
  // ============================================================

  InputImage? _convertCameraImage(
      CameraImage image,
      CameraDescription camera,
      ) {
    try {
      if (Platform.isAndroid) {
        return _convertAndroidImage(
          image,
          camera,
        );
      }

      if (Platform.isIOS) {
        return _convertIOSImage(
          image,
          camera,
        );
      }

      debugPrint(
        'Object detection is supported only on Android/iOS.',
      );

      return null;
    } catch (e) {
      debugPrint(
        'Camera image conversion error: $e',
      );

      return null;
    }
  }

  // ============================================================
  // ANDROID IMAGE CONVERSION
  // ============================================================

  InputImage? _convertAndroidImage(
      CameraImage image,
      CameraDescription camera,
      ) {
    // Android normally provides YUV420.
    if (image.planes.length != 3) {
      debugPrint(
        'Invalid Android image planes: '
            '${image.planes.length}',
      );

      return null;
    }

    final Uint8List nv21Bytes =
    _convertYUV420ToNV21(image);

    if (nv21Bytes.isEmpty) {
      return null;
    }

    final InputImageRotation rotation =
    _getRotation(camera);

    final InputImageMetadata metadata =
    InputImageMetadata(
      size: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      rotation: rotation,
      format: InputImageFormat.nv21,
      bytesPerRow: image.width,
    );

    return InputImage.fromBytes(
      bytes: nv21Bytes,
      metadata: metadata,
    );
  }

  // ============================================================
  // YUV420 → NV21
  // ============================================================

  Uint8List _convertYUV420ToNV21(
      CameraImage image,
      ) {
    final int width = image.width;
    final int height = image.height;

    final Plane yPlane =
    image.planes[0];

    final Plane uPlane =
    image.planes[1];

    final Plane vPlane =
    image.planes[2];

    // NV21 = Y + VU
    final int ySize =
        width * height;

    final int uvSize =
        width * height ~/ 2;

    final Uint8List nv21 =
    Uint8List(
      ySize + uvSize,
    );

    int outputIndex = 0;

    // ==========================================================
    // Y PLANE
    // ==========================================================

    for (int row = 0;
    row < height;
    row++) {
      final int rowStart =
          row * yPlane.bytesPerRow;

      for (int col = 0;
      col < width;
      col++) {
        final int index =
            rowStart + col;

        if (index <
            yPlane.bytes.length) {
          nv21[outputIndex++] =
          yPlane.bytes[index];
        }
      }
    }

    // ==========================================================
    // VU PLANE
    // ==========================================================

    final int uvWidth =
        width ~/ 2;

    final int uvHeight =
        height ~/ 2;

    final int uPixelStride =
        uPlane.bytesPerPixel ?? 1;

    final int vPixelStride =
        vPlane.bytesPerPixel ?? 1;

    for (int row = 0;
    row < uvHeight;
    row++) {
      final int uRowStart =
          row * uPlane.bytesPerRow;

      final int vRowStart =
          row * vPlane.bytesPerRow;

      for (int col = 0;
      col < uvWidth;
      col++) {
        final int uIndex =
            uRowStart +
                col * uPixelStride;

        final int vIndex =
            vRowStart +
                col * vPixelStride;

        if (vIndex <
            vPlane.bytes.length &&
            uIndex <
                uPlane.bytes.length) {
          // NV21 = V + U
          nv21[outputIndex++] =
          vPlane.bytes[vIndex];

          nv21[outputIndex++] =
          uPlane.bytes[uIndex];
        }
      }
    }

    return nv21;
  }

  // ============================================================
  // IOS IMAGE CONVERSION
  // ============================================================

  InputImage? _convertIOSImage(
      CameraImage image,
      CameraDescription camera,
      ) {
    if (image.planes.length != 1) {
      debugPrint(
        'Invalid iOS image planes: '
            '${image.planes.length}',
      );

      return null;
    }

    final Plane plane =
        image.planes.first;

    final InputImageMetadata metadata =
    InputImageMetadata(
      size: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      rotation: _getRotation(camera),
      format: InputImageFormat.bgra8888,
      bytesPerRow: plane.bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: metadata,
    );
  }

  // ============================================================
  // CAMERA ROTATION
  // ============================================================

  InputImageRotation _getRotation(
      CameraDescription camera,
      ) {
    switch (camera.sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;

      case 180:
        return InputImageRotation.rotation180deg;

      case 270:
        return InputImageRotation.rotation270deg;

      case 0:
        return InputImageRotation.rotation0deg;

      default:
        return InputImageRotation.rotation0deg;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    _lastResults = [];
    _lastDetectionTime = null;

    await _objectDetector.close();
  }
}