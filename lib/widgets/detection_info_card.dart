
import 'package:flutter/material.dart';

class DetectionInfoCard extends StatelessWidget {
final String objectName;
final double confidence;
final int objectCount;

const DetectionInfoCard({
super.key,
required this.objectName,
required this.confidence,
required this.objectCount,
});

@override
Widget build(BuildContext context) {
final double percentage =
(confidence * 100).clamp(0, 100);

return Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.black.withOpacity(0.78),
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.white.withOpacity(0.12),
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.25),
blurRadius: 15,
offset: const Offset(0, 6),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 38,
height: 38,
decoration: BoxDecoration(
color: Colors.greenAccent.withOpacity(0.15),
borderRadius: BorderRadius.circular(12),
),
child: const Icon(
Icons.auto_awesome,
color: Colors.greenAccent,
size: 21,
),
),
const SizedBox(width: 11),

const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'OBJECT DETECTED',
style: TextStyle(
color: Colors.greenAccent,
fontSize: 10,
fontWeight: FontWeight.w800,
letterSpacing: 1.1,
),
),
SizedBox(height: 2),
Text(
'ML Kit Analysis',
style: TextStyle(
color: Colors.white54,
fontSize: 10,
),
),
],
),
),

Container(
padding: const EdgeInsets.symmetric(
horizontal: 9,
vertical: 5,
),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.08),
borderRadius: BorderRadius.circular(20),
),
child: Text(
'$objectCount object${objectCount == 1 ? '' : 's'}',
style: const TextStyle(
color: Colors.white70,
fontSize: 10,
fontWeight: FontWeight.w600,
),
),
),
],
),

const SizedBox(height: 16),

Row(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Expanded(
child: Text(
objectName,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.white,
fontSize: 22,
fontWeight: FontWeight.w800,
),
),
),

const SizedBox(width: 10),

Text(
'${percentage.toStringAsFixed(0)}%',
style: const TextStyle(
color: Colors.greenAccent,
fontSize: 20,
fontWeight: FontWeight.w900,
),
),
],
),

const SizedBox(height: 10),

ClipRRect(
borderRadius: BorderRadius.circular(10),
child: LinearProgressIndicator(
value: percentage / 100,
minHeight: 7,
backgroundColor: Colors.white12,
valueColor:
const AlwaysStoppedAnimation<Color>(
Colors.greenAccent,
),
),
),

const SizedBox(height: 7),

const Text(
'Detection confidence',
style: TextStyle(
color: Colors.white54,
fontSize: 10,
),
),
],
),
);
}
}

