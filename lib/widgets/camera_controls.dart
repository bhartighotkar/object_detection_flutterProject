
import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
final bool isDetecting;
final bool isFlashOn;
final VoidCallback onStartDetection;
final VoidCallback onStopDetection;
final VoidCallback onToggleFlash;
final VoidCallback onSwitchCamera;

const CameraControls({
super.key,
required this.isDetecting,
required this.isFlashOn,
required this.onStartDetection,
required this.onStopDetection,
required this.onToggleFlash,
required this.onSwitchCamera,
});

@override
Widget build(BuildContext context) {
return SafeArea(
child: Container(
padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
decoration: BoxDecoration(
color: Colors.black.withOpacity(0.82),
borderRadius: const BorderRadius.vertical(
top: Radius.circular(28),
),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
// Small drag indicator
Container(
width: 42,
height: 4,
margin: const EdgeInsets.only(bottom: 16),
decoration: BoxDecoration(
color: Colors.white38,
borderRadius: BorderRadius.circular(10),
),
),

Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
_ControlButton(
icon: isFlashOn
? Icons.flash_on_rounded
    : Icons.flash_off_rounded,
label: isFlashOn ? 'Flash On' : 'Flash',
onTap: onToggleFlash,
active: isFlashOn,
),

_MainDetectionButton(
isDetecting: isDetecting,
onStart: onStartDetection,
onStop: onStopDetection,
),

_ControlButton(
icon: Icons.cameraswitch_rounded,
label: 'Switch',
onTap: onSwitchCamera,
),
],
),
],
),
),
);
}
}

class _ControlButton extends StatelessWidget {
final IconData icon;
final String label;
final VoidCallback onTap;
final bool active;

const _ControlButton({
required this.icon,
required this.label,
required this.onTap,
this.active = false,
});

@override
Widget build(BuildContext context) {
return InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(18),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 54,
height: 54,
decoration: BoxDecoration(
color: active
? Colors.amber.withOpacity(0.22)
    : Colors.white.withOpacity(0.10),
shape: BoxShape.circle,
border: Border.all(
color: active
? Colors.amber
    : Colors.white24,
),
),
child: Icon(
icon,
color: active ? Colors.amber : Colors.white,
size: 25,
),
),
const SizedBox(height: 7),
Text(
label,
style: const TextStyle(
color: Colors.white,
fontSize: 11,
fontWeight: FontWeight.w600,
),
),
],
),
);
}
}

class _MainDetectionButton extends StatelessWidget {
final bool isDetecting;
final VoidCallback onStart;
final VoidCallback onStop;

const _MainDetectionButton({
required this.isDetecting,
required this.onStart,
required this.onStop,
});

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: isDetecting ? onStop : onStart,
child: AnimatedContainer(
duration: const Duration(milliseconds: 250),
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 13,
),
decoration: BoxDecoration(
color: isDetecting
? Colors.redAccent
    : Colors.green,
borderRadius: BorderRadius.circular(18),
boxShadow: [
BoxShadow(
color: (isDetecting
? Colors.redAccent
    : Colors.green)
    .withOpacity(0.35),
blurRadius: 14,
spreadRadius: 1,
),
],
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
isDetecting
? Icons.stop_rounded
    : Icons.play_arrow_rounded,
color: Colors.white,
size: 22,
),
const SizedBox(width: 7),
Text(
isDetecting ? 'Stop Detection' : 'Start Detection',
style: const TextStyle(
color: Colors.white,
fontSize: 13,
fontWeight: FontWeight.w800,
),
),
],
),
),
);
}
}

