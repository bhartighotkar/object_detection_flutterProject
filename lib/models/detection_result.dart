//
// import 'package:flutter/material.dart';
//
// class DetectionResult {
// final Rect boundingBox;
// final String label;
// final double confidence;
// final int? trackingId;
//
// const DetectionResult({
// required this.boundingBox,
// required this.label,
// required this.confidence,
// this.trackingId,
// });
//
// DetectionResult copyWith({
// Rect? boundingBox,
// String? label,
// double? confidence,
// int? trackingId,
// }) {
// return DetectionResult(
// boundingBox: boundingBox ?? this.boundingBox,
// label: label ?? this.label,
// confidence: confidence ?? this.confidence,
// trackingId: trackingId ?? this.trackingId,
// );
// }
// }
//



import 'dart:ui';

class DetectionResult {
final Rect boundingBox;
final String label;
final double confidence;
final int? trackingId;

const DetectionResult({
required this.boundingBox,
required this.label,
required this.confidence,
this.trackingId,
});
}

