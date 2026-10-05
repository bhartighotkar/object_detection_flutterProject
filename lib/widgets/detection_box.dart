//
// import 'package:flutter/material.dart';
//
// class DetectionBox extends StatelessWidget {
//   final Rect boundingBox;
//   final String label;
//   final double confidence;
//
//   final Size imageSize;
//   final Size previewSize;
//
//   const DetectionBox({
//     super.key,
//     required this.boundingBox,
//     required this.label,
//     required this.confidence,
//     required this.imageSize,
//     required this.previewSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (imageSize.width <= 0 ||
//         imageSize.height <= 0 ||
//         previewSize.width <= 0 ||
//         previewSize.height <= 0) {
//       return const SizedBox.shrink();
//     }
//
//     final Rect mappedBox =
//     _mapBoundingBox();
//
//     return Positioned(
//       left: mappedBox.left,
//       top: mappedBox.top,
//       width: mappedBox.width,
//       height: mappedBox.height,
//       child: IgnorePointer(
//         child: _buildBox(),
//       ),
//     );
//   }
//
//   // ============================================================
//   // MAP ML KIT COORDINATES TO SCREEN COORDINATES
//   // ============================================================
//
//   Rect _mapBoundingBox() {
//     final double scaleX =
//         previewSize.width / imageSize.width;
//
//     final double scaleY =
//         previewSize.height / imageSize.height;
//
//     double left =
//         boundingBox.left * scaleX;
//
//     double top =
//         boundingBox.top * scaleY;
//
//     double right =
//         boundingBox.right * scaleX;
//
//     double bottom =
//         boundingBox.bottom * scaleY;
//
//     // Keep box inside screen.
//     left = left.clamp(
//       0.0,
//       previewSize.width,
//     );
//
//     top = top.clamp(
//       0.0,
//       previewSize.height,
//     );
//
//     right = right.clamp(
//       0.0,
//       previewSize.width,
//     );
//
//     bottom = bottom.clamp(
//       0.0,
//       previewSize.height,
//     );
//
//     return Rect.fromLTRB(
//       left,
//       top,
//       right,
//       bottom,
//     );
//   }
//
//   // ============================================================
//   // DETECTION BOX UI
//   // ============================================================
//
//   Widget _buildBox() {
//     final int percentage =
//     (confidence * 100).round().clamp(0, 100);
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         // Main border
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.greenAccent,
//               width: 2.5,
//             ),
//             borderRadius:
//             BorderRadius.circular(10),
//           ),
//         ),
//
//         // Label
//         Positioned(
//           left: 0,
//           top: -34,
//           child: Container(
//             padding:
//             const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 7,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.78),
//               borderRadius:
//               BorderRadius.circular(9),
//               border: Border.all(
//                 color: Colors.greenAccent
//                     .withOpacity(0.7),
//               ),
//             ),
//             child: Row(
//               mainAxisSize:
//               MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.center_focus_strong_rounded,
//                   color: Colors.greenAccent,
//                   size: 14,
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight:
//                     FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   '$percentage%',
//                   style: const TextStyle(
//                     color: Colors.greenAccent,
//                     fontSize: 11,
//                     fontWeight:
//                     FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // Corner markers
//         _corner(
//           alignment: Alignment.topLeft,
//         ),
//
//         _corner(
//           alignment: Alignment.topRight,
//         ),
//
//         _corner(
//           alignment: Alignment.bottomLeft,
//         ),
//
//         _corner(
//           alignment: Alignment.bottomRight,
//         ),
//       ],
//     );
//   }
//
//   // ============================================================
//   // CORNER
//   // ============================================================
//
//   Widget _corner({
//     required Alignment alignment,
//   }) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: 16,
//         height: 16,
//         decoration: BoxDecoration(
//           border: Border(
//             top: alignment == Alignment.topLeft ||
//                 alignment == Alignment.topRight
//                 ? const BorderSide(
//               color: Colors.greenAccent,
//               width: 3,
//             )
//                 : BorderSide.none,
//             bottom: alignment == Alignment.bottomLeft ||
//                 alignment == Alignment.bottomRight
//                 ? const BorderSide(
//               color: Colors.greenAccent,
//               width: 3,
//             )
//                 : BorderSide.none,
//             left: alignment == Alignment.topLeft ||
//                 alignment == Alignment.bottomLeft
//                 ? const BorderSide(
//               color: Colors.greenAccent,
//               width: 3,
//             )
//                 : BorderSide.none,
//             right: alignment == Alignment.topRight ||
//                 alignment == Alignment.bottomRight
//                 ? const BorderSide(
//               color: Colors.greenAccent,
//               width: 3,
//             )
//                 : BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class DetectionBox extends StatelessWidget {
  final Rect boundingBox;
  final String label;
  final double confidence;

  // Size of the original ML Kit camera image.
  final Size imageSize;

  // Size of the area where CameraPreview is displayed.
  final Size previewSize;

  // Whether front camera is being used.
  final bool isFrontCamera;

  const DetectionBox({
    super.key,
    required this.boundingBox,
    required this.label,
    required this.confidence,
    required this.imageSize,
    required this.previewSize,
    this.isFrontCamera = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSize.width <= 0 ||
        imageSize.height <= 0 ||
        previewSize.width <= 0 ||
        previewSize.height <= 0) {
      return const SizedBox.shrink();
    }

    final Rect mappedBox = _mapBoundingBox();

    if (mappedBox.width <= 0 ||
        mappedBox.height <= 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: mappedBox.left,
      top: mappedBox.top,
      width: mappedBox.width,
      height: mappedBox.height,
      child: IgnorePointer(
        child: _buildDetectionUI(),
      ),
    );
  }

  // ============================================================
  // EXACT BOX MAPPING
  // ============================================================

  Rect _mapBoundingBox() {
    /*
      ML Kit gives coordinates according to the camera image.

      CameraPreview uses BoxFit.cover.

      Therefore:

      1. Calculate scale required to COVER the screen.
      2. Calculate how much of the image gets cropped.
      3. Apply that crop offset.
      4. Handle front-camera mirroring.
    */

    final double scale = _getCoverScale();

    final double displayedImageWidth =
        imageSize.width * scale;

    final double displayedImageHeight =
        imageSize.height * scale;

    // Because BoxFit.cover centers the image,
    // the overflow is cropped equally from both sides.
    final double cropX =
        (displayedImageWidth -
            previewSize.width) /
            2;

    final double cropY =
        (displayedImageHeight -
            previewSize.height) /
            2;

    double left =
        boundingBox.left * scale - cropX;

    double top =
        boundingBox.top * scale - cropY;

    double right =
        boundingBox.right * scale - cropX;

    double bottom =
        boundingBox.bottom * scale - cropY;

    // ==========================================================
    // FRONT CAMERA MIRROR
    // ==========================================================

    if (isFrontCamera) {
      final double mirroredLeft =
          previewSize.width - right;

      final double mirroredRight =
          previewSize.width - left;

      left = mirroredLeft;
      right = mirroredRight;
    }

    // ==========================================================
    // CLAMP TO SCREEN
    // ==========================================================

    left = left.clamp(
      0.0,
      previewSize.width,
    );

    top = top.clamp(
      0.0,
      previewSize.height,
    );

    right = right.clamp(
      0.0,
      previewSize.width,
    );

    bottom = bottom.clamp(
      0.0,
      previewSize.height,
    );

    return Rect.fromLTRB(
      left,
      top,
      right,
      bottom,
    );
  }

  // ============================================================
  // BOX FIT COVER SCALE
  // ============================================================

  double _getCoverScale() {
    final double scaleX =
        previewSize.width /
            imageSize.width;

    final double scaleY =
        previewSize.height /
            imageSize.height;

    // BoxFit.cover uses the LARGER scale.
    return scaleX > scaleY
        ? scaleX
        : scaleY;
  }

  // ============================================================
  // DETECTION UI
  // ============================================================

  Widget _buildDetectionUI() {
    final int percentage =
    (confidence * 100)
        .round()
        .clamp(0, 100);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ======================================================
        // MAIN BOX
        // ======================================================

        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.greenAccent,
              width: 2.5,
            ),
            borderRadius:
            BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent
                    .withOpacity(0.25),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),

        // ======================================================
        // LABEL
        // ======================================================

        Positioned(
          left: 0,
          top: -38,
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.82),
              borderRadius:
              BorderRadius.circular(9),
              border: Border.all(
                color: Colors.greenAccent
                    .withOpacity(0.65),
              ),
            ),
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                const Icon(
                  Icons
                      .center_focus_strong_rounded,
                  color:
                  Colors.greenAccent,
                  size: 14,
                ),

                const SizedBox(width: 5),

                Text(
                  label,
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 7),

                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent
                        .withOpacity(0.15),
                    borderRadius:
                    BorderRadius.circular(5),
                  ),
                  child: Text(
                    '$percentage%',
                    style:
                    const TextStyle(
                      color:
                      Colors.greenAccent,
                      fontSize: 10,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ======================================================
        // CORNERS
        // ======================================================

        _corner(
          Alignment.topLeft,
          top: true,
          left: true,
        ),

        _corner(
          Alignment.topRight,
          top: true,
          right: true,
        ),

        _corner(
          Alignment.bottomLeft,
          bottom: true,
          left: true,
        ),

        _corner(
          Alignment.bottomRight,
          bottom: true,
          right: true,
        ),
      ],
    );
  }

  // ============================================================
  // CORNER
  // ============================================================

  Widget _corner(
      Alignment alignment, {
        bool top = false,
        bool bottom = false,
        bool left = false,
        bool right = false,
      }) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 18,
        height: 18,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: top
                  ? const BorderSide(
                color:
                Colors.greenAccent,
                width: 3,
              )
                  : BorderSide.none,

              bottom: bottom
                  ? const BorderSide(
                color:
                Colors.greenAccent,
                width: 3,
              )
                  : BorderSide.none,

              left: left
                  ? const BorderSide(
                color:
                Colors.greenAccent,
                width: 3,
              )
                  : BorderSide.none,

              right: right
                  ? const BorderSide(
                color:
                Colors.greenAccent,
                width: 3,
              )
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}