//
//
// import 'package:flutter/material.dart';
//
// import 'object_detection_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7FAF8),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(
//             20,
//             18,
//             20,
//             30,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ------------------------------------------------
//               // HEADER
//               // ------------------------------------------------
//               Row(
//                 children: [
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF10271E),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Icon(
//                       Icons.center_focus_strong_rounded,
//                       color: Colors.greenAccent,
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Object Vision',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                         SizedBox(height: 2),
//                         Text(
//                           'AI Object Detection',
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.settings_outlined,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//
//               // ------------------------------------------------
//               // TITLE
//               // ------------------------------------------------
//               const Text(
//                 'Explore the world',
//                 style: TextStyle(
//                   fontSize: 29,
//                   fontWeight: FontWeight.w800,
//                   height: 1.1,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 'Point your camera at an object and let AI analyze it.',
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 14,
//                   height: 1.5,
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // ------------------------------------------------
//               // OBJECT DETECTION CARD
//               // ------------------------------------------------
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                       const ObjectDetectionScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(22),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF10271E),
//                     borderRadius: BorderRadius.circular(28),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.12),
//                         blurRadius: 25,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 52,
//                             height: 52,
//                             decoration: BoxDecoration(
//                               color: Colors.greenAccent
//                                   .withOpacity(0.12),
//                               borderRadius:
//                               BorderRadius.circular(16),
//                             ),
//                             child: const Icon(
//                               Icons.document_scanner_rounded,
//                               color: Colors.greenAccent,
//                               size: 27,
//                             ),
//                           ),
//
//                           const Spacer(),
//
//                           const Icon(
//                             Icons.arrow_forward_rounded,
//                             color: Colors.white54,
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 28),
//
//                       const Text(
//                         'Object Detection',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       const Text(
//                         'Detect objects in real-time using your camera and Google ML Kit.',
//                         style: TextStyle(
//                           color: Colors.white60,
//                           fontSize: 13,
//                           height: 1.5,
//                         ),
//                       ),
//
//                       const SizedBox(height: 22),
//
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.greenAccent,
//                           borderRadius:
//                           BorderRadius.circular(14),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.camera_alt_rounded,
//                               color: Color(0xFF07110D),
//                               size: 19,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               'Start Scanning',
//                               style: TextStyle(
//                                 color: Color(0xFF07110D),
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 28),
//
//               // ------------------------------------------------
//               // FEATURES
//               // ------------------------------------------------
//               const Text(
//                 'Features',
//                 style: TextStyle(
//                   fontSize: 19,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _featureCard(
//                       Icons.bolt_rounded,
//                       'Real-time',
//                       'Live detection',
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _featureCard(
//                       Icons.crop_free_rounded,
//                       'Smart Scan',
//                       'Bounding boxes',
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _featureCard(
//                       Icons.analytics_outlined,
//                       'Confidence',
//                       'AI score',
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _featureCard(
//                       Icons.flash_on_rounded,
//                       'Camera',
//                       'Flash support',
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 28),
//
//               // ------------------------------------------------
//               // HOW IT WORKS
//               // ------------------------------------------------
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(22),
//                   border: Border.all(
//                     color: Colors.black.withOpacity(0.06),
//                   ),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'How it works',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//
//                     SizedBox(height: 18),
//
//                     _Step(
//                       number: '01',
//                       title: 'Open camera',
//                       description:
//                       'Point your camera at an object.',
//                     ),
//
//                     _Step(
//                       number: '02',
//                       title: 'AI analyzes',
//                       description:
//                       'ML Kit processes the camera frames.',
//                     ),
//
//                     _Step(
//                       number: '03',
//                       title: 'See results',
//                       description:
//                       'Detected objects appear with confidence.',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _featureCard(
//       IconData icon,
//       String title,
//       String subtitle,
//       ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.black.withOpacity(0.06),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             icon,
//             color: const Color(0xFF15966A),
//             size: 25,
//           ),
//
//           const SizedBox(height: 14),
//
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.w800,
//               fontSize: 14,
//             ),
//           ),
//
//           const SizedBox(height: 3),
//
//           Text(
//             subtitle,
//             style: const TextStyle(
//               color: Colors.black45,
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Step extends StatelessWidget {
//   final String number;
//   final String title;
//   final String description;
//
//   const _Step({
//     required this.number,
//     required this.title,
//     required this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 38,
//             height: 38,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: const Color(0xFFE9F8F1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               number,
//               style: const TextStyle(
//                 color: Color(0xFF15966A),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//
//                 const SizedBox(height: 3),
//
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontSize: 11,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import 'object_detection_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color darkGreen = Color(0xFF07110D);
  static const Color darkCard = Color(0xFF10271E);
  static const Color primaryGreen = Color(0xFF15966A);
  static const Color mint = Color(0xFF6FF7BE);
  static const Color lightGreen = Color(0xFFE9F8F1);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final bool smallScreen = screenSize.width < 380;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.fromLTRB(
            smallScreen ? 16 : 20,
            16,
            smallScreen ? 16 : 20,
            30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              _buildHeader(context),

              const SizedBox(height: 28),

              // ==================================================
              // WELCOME / TITLE
              // ==================================================

              _buildWelcomeSection(),

              const SizedBox(height: 22),

              // ==================================================
              // MAIN SCAN CARD
              // ==================================================

              _buildMainDetectionCard(context),

              const SizedBox(height: 24),

              // ==================================================
              // QUICK TOOLS TITLE
              // ==================================================

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Explore Object Vision',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF10271E),
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 13,
                          color: primaryGreen,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'AI Tools',
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ==================================================
              // FEATURE CARDS
              // ==================================================

              _buildFeatureGrid(context),

              const SizedBox(height: 24),

              // ==================================================
              // AI STATUS CARD
              // ==================================================

              _buildAIStatusCard(),

              const SizedBox(height: 24),

              // ==================================================
              // HOW IT WORKS
              // ==================================================

              _buildHowItWorks(),

              const SizedBox(height: 24),

              // ==================================================
              // TIP CARD
              // ==================================================

              _buildTipCard(),

              const SizedBox(height: 12),

              // ==================================================
              // FOOTER
              // ==================================================

              Center(
                child: Text(
                  'Object Vision • AI-powered visual intelligence',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.38),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // LOGO
        Container(
          width: 52,
          height: 52,

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF173F2E),
                darkGreen,
              ],
            ),

            borderRadius: BorderRadius.circular(17),

            border: Border.all(
              color: mint.withOpacity(0.30),
            ),

            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.15),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer scanning circle
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mint.withOpacity(0.35),
                    width: 1,
                  ),
                ),
              ),

              // Eye
              const Icon(
                Icons.visibility_rounded,
                color: mint,
                size: 25,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // APP NAME
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Object Vision',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: darkGreen,
                  letterSpacing: -0.3,
                ),
              ),

              SizedBox(height: 3),

              Text(
                'See • Detect • Understand',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // SETTINGS
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),

          child: InkWell(
            borderRadius: BorderRadius.circular(15),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const SettingScreen(),
                ),
              );
            },

            child: Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),

                border: Border.all(
                  color: Colors.black.withOpacity(0.07),
                ),
              ),

              child: const Icon(
                Icons.settings_outlined,
                color: darkGreen,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WELCOME SECTION
  // ============================================================

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 7),

            const Text(
              'AI VISION READY',
              style: TextStyle(
                color: primaryGreen,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          'Explore the world\nthrough AI.',
          style: TextStyle(
            fontSize: 31,
            height: 1.08,
            fontWeight: FontWeight.w900,
            color: darkGreen,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: 9),

        const Text(
          'Point your camera at an object and let Object Vision identify and analyze it in real time.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MAIN DETECTION CARD
  // ============================================================

  Widget _buildMainDetectionCard(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ObjectDetectionScreen(),
            ),
          );
        },


      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF163D2C),
              Color(0xFF07110D),
            ],
          ),

          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,

                  decoration: BoxDecoration(
                    color: mint.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: mint.withOpacity(0.18),
                    ),
                  ),

                  child: const Icon(
                    Icons.visibility_rounded,
                    color: mint,
                    size: 29,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.10),
                    ),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: mint,
                        size: 7,
                      ),

                      SizedBox(width: 6),

                      Text(
                        'LIVE AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Object Detection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Recognize objects using your device camera with real-time AI analysis.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // VISUAL CAMERA AREA
            Container(
              height: 92,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.045),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),

              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Fake camera frame
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 18,
                    bottom: 18,

                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: mint.withOpacity(0.20),
                          width: 1,
                        ),
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  // Center target
                  Container(
                    width: 54,
                    height: 54,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: mint.withOpacity(0.75),
                        width: 1.5,
                      ),
                    ),

                    child: const Icon(
                      Icons.center_focus_strong_rounded,
                      color: mint,
                      size: 28,
                    ),
                  ),

                  // Small detection points
                  Positioned(
                    left: 48,
                    top: 25,
                    child: _smallDetectionDot(),
                  ),

                  Positioned(
                    right: 55,
                    bottom: 22,
                    child: _smallDetectionDot(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // START BUTTON
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),

              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    color: darkGreen,
                    size: 19,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Start Scanning',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  SizedBox(width: 7),

                  Icon(
                    Icons.arrow_forward_rounded,
                    color: darkGreen,
                    size: 17,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FEATURE GRID
  // ============================================================

  Widget _buildFeatureGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _featureCard(
                icon: Icons.center_focus_strong_rounded,
                title: 'Smart Scan',
                subtitle: 'Detect objects',
                iconColor: primaryGreen,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _featureCard(
                icon: Icons.crop_free_rounded,
                title: 'Live Boxes',
                subtitle: 'Track objects',
                iconColor: const Color(0xFF6A5AE0),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _featureCard(
                icon: Icons.analytics_outlined,
                title: 'Confidence',
                subtitle: 'AI score',
                iconColor: const Color(0xFFE18A24),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _featureCard(
                icon: Icons.flash_on_rounded,
                title: 'Flash',
                subtitle: 'Low light scan',
                iconColor: const Color(0xFFDB9B20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),

        border: Border.all(
          color: Colors.black.withOpacity(0.055),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            title,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AI STATUS
  // ============================================================

  Widget _buildAIStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(23),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: mint.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.psychology_rounded,
              color: mint,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Engine Ready',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Google ML Kit • Real-time detection',
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
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: mint.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: mint,
                  size: 13,
                ),

                SizedBox(width: 4),

                Text(
                  'READY',
                  style: TextStyle(
                    color: mint,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
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
  // HOW IT WORKS
  // ============================================================

  Widget _buildHowItWorks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),

        border: Border.all(
          color: Colors.black.withOpacity(0.055),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: primaryGreen,
                size: 20,
              ),

              SizedBox(width: 8),

              Text(
                'How it works',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _howStep(
            number: '01',
            icon: Icons.camera_alt_rounded,
            title: 'Point your camera',
            description:
            'Place the object inside the camera view.',
          ),

          _verticalLine(),

          _howStep(
            number: '02',
            icon: Icons.psychology_rounded,
            title: 'AI analyzes',
            description:
            'ML Kit analyzes the live camera frame.',
          ),

          _verticalLine(),

          _howStep(
            number: '03',
            icon: Icons.crop_free_rounded,
            title: 'See the result',
            description:
            'Object name, confidence and bounding box appear.',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOW STEP
  // ============================================================

  Widget _howStep({
    required String number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: primaryGreen,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                      color: primaryGreen,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),

              Text(
                description,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 10.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VERTICAL LINE
  // ============================================================

  Widget _verticalLine() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        top: 4,
        bottom: 4,
      ),

      width: 1,
      height: 16,

      color: primaryGreen.withOpacity(0.20),
    );
  }

  // ============================================================
  // TIP CARD
  // ============================================================

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F4),
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: primaryGreen.withOpacity(0.12),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFFE09A20),
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detection tip',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'For better results, keep the object clearly visible and use good lighting.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10.5,
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
  // SMALL DETECTION DOT
  // ============================================================

  Widget _smallDetectionDot() {
    return Container(
      width: 7,
      height: 7,

      decoration: BoxDecoration(
        color: mint,
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color: mint.withOpacity(0.45),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}