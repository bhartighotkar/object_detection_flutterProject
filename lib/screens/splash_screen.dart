// // import 'dart:async';
// //
// // import 'package:flutter/material.dart';
// //
// // import 'home_screen.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //
// //   @override
// //   State<SplashScreen> createState() =>
// //       _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _scaleAnimation;
// //   late Animation<double> _fadeAnimation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1200),
// //     );
// //
// //     _scaleAnimation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.easeOutBack,
// //     );
// //
// //     _fadeAnimation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.easeIn,
// //     );
// //
// //     _controller.forward();
// //
// //     Timer(
// //       const Duration(seconds: 2),
// //           () {
// //         if (!mounted) return;
// //
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (_) => const HomeScreen(),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF07110D),
// //       body: Center(
// //         child: AnimatedBuilder(
// //           animation: _controller,
// //           builder: (context, child) {
// //             return Opacity(
// //               opacity: _fadeAnimation.value,
// //               child: Transform.scale(
// //                 scale: _scaleAnimation.value,
// //                 child: child,
// //               ),
// //             );
// //           },
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Container(
// //                 width: 100,
// //                 height: 100,
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF10271E),
// //                   borderRadius:
// //                   BorderRadius.circular(30),
// //                   border: Border.all(
// //                     color: Colors.greenAccent
// //                         .withOpacity(0.4),
// //                     width: 1.5,
// //                   ),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.greenAccent
// //                           .withOpacity(0.18),
// //                       blurRadius: 30,
// //                       spreadRadius: 5,
// //                     ),
// //                   ],
// //                 ),
// //                 child: const Icon(
// //                   Icons.center_focus_strong_rounded,
// //                   color: Colors.greenAccent,
// //                   size: 52,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 25),
// //
// //               const Text(
// //                 'Object Vision',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 30,
// //                   fontWeight: FontWeight.w800,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 8),
// //
// //               Text(
// //                 'AI-powered object detection',
// //                 style: TextStyle(
// //                   color: Colors.white
// //                       .withOpacity(0.55),
// //                   fontSize: 14,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 35),
// //
// //               const SizedBox(
// //                 width: 24,
// //                 height: 24,
// //                 child: CircularProgressIndicator(
// //                   strokeWidth: 2.5,
// //                   color: Colors.greenAccent,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import 'home_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     );
//
//     _scaleAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     );
//
//     _animationController.forward();
//
//     Timer(const Duration(seconds: 2), () {
//       if (!mounted) return;
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const HomeScreen(),
//         ),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF07110D),
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return FadeTransition(
//               opacity: _fadeAnimation,
//               child: ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: child,
//               ),
//             );
//           },
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 105,
//                 height: 105,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF10271E),
//                   borderRadius: BorderRadius.circular(30),
//                   border: Border.all(
//                     color: Colors.greenAccent.withOpacity(0.35),
//                     width: 1.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.greenAccent.withOpacity(0.15),
//                       blurRadius: 35,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.center_focus_strong_rounded,
//                   color: Colors.greenAccent,
//                   size: 55,
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//                 'Object Vision',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               Text(
//                 'AI-powered object detection',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.55),
//                   fontSize: 14,
//                 ),
//               ),
//
//               const SizedBox(height: 35),
//
//               const SizedBox(
//                 width: 25,
//                 height: 25,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   color: Colors.greenAccent,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _scanController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // MAIN ANIMATION
    // ==========================================================

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.35,
          end: 1.12,
        ).chain(
          CurveTween(
            curve: Curves.easeOutBack,
          ),
        ),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.12,
          end: 1.0,
        ).chain(
          CurveTween(
            curve: Curves.easeOut,
          ),
        ),
        weight: 30,
      ),
    ]).animate(_mainController);

    _logoFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.easeIn,
      ),
    );

    _textFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.35,
        0.85,
        curve: Curves.easeIn,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.35,
          0.9,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ==========================================================
    // LOGO PULSE
    // ==========================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    )..repeat(reverse: true);

    // ==========================================================
    // SCANNING ANIMATION
    // ==========================================================

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    )..repeat();

    _mainController.forward();

    // ==========================================================
    // GO TO HOME
    // ==========================================================

    Timer(
      const Duration(
        milliseconds: 2800,
      ),
          () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration:
            const Duration(milliseconds: 650),
            pageBuilder:
                (
                context,
                animation,
                secondaryAnimation,
                ) {
              return const HomeScreen();
            },
            transitionsBuilder:
                (
                context,
                animation,
                secondaryAnimation,
                child,
                ) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _scanController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize =
        MediaQuery.of(context).size;

    final double logoSize =
    screenSize.width < 360 ? 155 : 175;

    return Scaffold(
      backgroundColor:
      const Color(0xFF06110D),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ======================================================
          // BACKGROUND
          // ======================================================

          _buildBackground(),

          // ======================================================
          // MAIN CONTENT
          // ======================================================

          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _mainController,
                _pulseController,
                _scanController,
              ]),
              builder: (context, child) {
                return Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    // ==================================================
                    // LOGO
                    // ==================================================

                    Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _buildLogo(
                          logoSize,
                        ),
                      ),
                    ),

                    SizedBox(
                      height:
                      screenSize.width < 360
                          ? 26
                          : 32,
                    ),

                    // ==================================================
                    // APP NAME
                    // ==================================================

                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child:
                        _buildAppName(),
                      ),
                    ),

                    const SizedBox(
                      height: 9,
                    ),

                    // ==================================================
                    // SUBTITLE
                    // ==================================================

                    FadeTransition(
                      opacity: _textFade,
                      child: Text(
                        'See • Detect • Understand',
                        textAlign:
                        TextAlign.center,
                        style: TextStyle(
                          color: Colors.white
                              .withOpacity(0.58),
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // ==================================================
                    // LOADING
                    // ==================================================

                    FadeTransition(
                      opacity: _textFade,
                      child:
                      _buildLoadingIndicator(),
                    ),
                  ],
                );
              },
            ),
          ),

          // ======================================================
          // BOTTOM VERSION
          // ======================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: FadeTransition(
              opacity: _textFade,
              child: const Text(
                'AI-powered visual intelligence',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BACKGROUND
  // ============================================================

  Widget _buildBackground() {
    return Stack(
      children: [
        // Main gradient
        Container(
          decoration:
          const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF06110D),
                Color(0xFF081A13),
                Color(0xFF03100B),
              ],
            ),
          ),
        ),

        // Green glow
        Positioned(
          top: -130,
          right: -100,
          child: _glowCircle(
            size: 300,
            color: const Color(
              0xFF18E69A,
            ),
          ),
        ),

        // Cyan glow
        Positioned(
          bottom: -160,
          left: -120,
          child: _glowCircle(
            size: 330,
            color: const Color(
              0xFF00C8FF,
            ),
          ),
        ),

        // Small decorative circles
        Positioned(
          top: 100,
          left: 30,
          child: _decorativeCircle(
            7,
            Colors.greenAccent,
          ),
        ),

        Positioned(
          top: 180,
          right: 35,
          child: _decorativeCircle(
            5,
            Colors.cyanAccent,
          ),
        ),

        Positioned(
          bottom: 150,
          right: 55,
          child: _decorativeCircle(
            6,
            Colors.greenAccent,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GLOW CIRCLE
  // ============================================================

  Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 100,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DECORATIVE CIRCLE
  // ============================================================

  Widget _decorativeCircle(
      double size,
      Color color,
      ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OBJECT VISION LOGO
  // ============================================================

  Widget _buildLogo(double size) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulse =
            1.0 +
                (_pulseController.value *
                    0.025);

        return Transform.scale(
          scale: pulse,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow
                Container(
                  width: size,
                  height: size,
                  decoration:
                  BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF18E69A,
                        ).withOpacity(0.18),
                        blurRadius: 45,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),

                // Main logo container
                Container(
                  width: size * 0.72,
                  height: size * 0.72,
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      size * 0.25,
                    ),
                    gradient:
                    const LinearGradient(
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color(0xFF123D2C),
                        Color(0xFF0B241A),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(
                        0xFF39F5A5,
                      ).withOpacity(0.45),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF18E69A,
                        ).withOpacity(0.12),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: _buildEye(),
                ),

                // Scanning corners
                _buildCorner(
                  Alignment.topLeft,
                ),

                _buildCorner(
                  Alignment.topRight,
                ),

                _buildCorner(
                  Alignment.bottomLeft,
                ),

                _buildCorner(
                  Alignment.bottomRight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EYE ICON
  // ============================================================

  Widget _buildEye() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return CustomPaint(
          painter: _EyePainter(
            scanPosition:
            _scanController.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }

  // ============================================================
  // CORNER MARK
  // ============================================================

  Widget _buildCorner(
      Alignment alignment,
      ) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 22,
        height: 22,
        decoration:
        BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(
              color: Color(
                0xFF39F5A5,
              ),
              width: 2.5,
            )
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(
              color: Color(
                0xFF39F5A5,
              ),
              width: 2.5,
            )
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(
              color: Color(
                0xFF39F5A5,
              ),
              width: 2.5,
            )
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(
              color: Color(
                0xFF39F5A5,
              ),
              width: 2.5,
            )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP NAME
  // ============================================================

  Widget _buildAppName() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFF9CFFD5),
          ],
        ).createShader(bounds);
      },
      child: const Text(
        'Object Vision',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 31,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // ============================================================
  // LOADING INDICATOR
  // ============================================================

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            valueColor:
            const AlwaysStoppedAnimation<
                Color>(
              Color(0xFF39F5A5),
            ),
          ),
        ),

        const SizedBox(width: 11),

        const Text(
          'Initializing vision...',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// CUSTOM EYE PAINTER
// ================================================================

class _EyePainter extends CustomPainter {
  final double scanPosition;

  _EyePainter({
    required this.scanPosition,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final Paint eyePaint = Paint()
      ..color = const Color(
        0xFF8CFFD2,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final Paint irisPaint = Paint()
      ..color = const Color(
        0xFF39F5A5,
      )
      ..style = PaintingStyle.fill;

    final Paint pupilPaint = Paint()
      ..color = const Color(
        0xFF06110D,
      )
      ..style = PaintingStyle.fill;

    final double centerX =
        size.width / 2;

    final double centerY =
        size.height / 2;

    final double eyeWidth =
        size.width * 0.52;

    final double eyeHeight =
        size.height * 0.30;

    // ==========================================================
    // EYE SHAPE
    // ==========================================================

    final Path eyePath = Path();

    eyePath.moveTo(
      centerX - eyeWidth / 2,
      centerY,
    );

    eyePath.quadraticBezierTo(
      centerX,
      centerY - eyeHeight,
      centerX + eyeWidth / 2,
      centerY,
    );

    eyePath.quadraticBezierTo(
      centerX,
      centerY + eyeHeight,
      centerX - eyeWidth / 2,
      centerY,
    );

    canvas.drawPath(
      eyePath,
      eyePaint,
    );

    // ==========================================================
    // IRIS
    // ==========================================================

    final double irisRadius =
        size.width * 0.105;

    canvas.drawCircle(
      Offset(
        centerX,
        centerY,
      ),
      irisRadius,
      irisPaint,
    );

    // ==========================================================
    // PUPIL
    // ==========================================================

    canvas.drawCircle(
      Offset(
        centerX,
        centerY,
      ),
      irisRadius * 0.48,
      pupilPaint,
    );

    // ==========================================================
    // SCANNING LINE
    // ==========================================================

    final double scanX =
        size.width *
            (0.30 +
                scanPosition * 0.40);

    final Paint scanPaint = Paint()
      ..color = const Color(
        0xFF39F5A5,
      ).withOpacity(0.75)
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(
        scanX,
        centerY - eyeHeight * 0.65,
      ),
      Offset(
        scanX,
        centerY + eyeHeight * 0.65,
      ),
      scanPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _EyePainter oldDelegate,
      ) {
    return oldDelegate.scanPosition !=
        scanPosition;
  }
}