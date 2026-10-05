import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // ============================================================
  // SETTINGS KEYS
  // ============================================================

  static const String _showBoundingBoxKey =
      'setting_show_bounding_box';

  static const String _showConfidenceKey =
      'setting_show_confidence';

  static const String _highAccuracyKey =
      'setting_high_accuracy';

  static const String _autoStartKey =
      'setting_auto_start';

  static const String _rememberCameraKey =
      'setting_remember_camera';

  static const String _soundFeedbackKey =
      'setting_sound_feedback';

  static const String _vibrationFeedbackKey =
      'setting_vibration_feedback';

  static const String _darkModeKey =
      'setting_dark_mode';

  // ============================================================
  // DEFAULT VALUES
  // ============================================================

  bool _showBoundingBox = true;
  bool _showConfidence = true;
  bool _highAccuracy = true;

  bool _autoStart = false;
  bool _rememberCamera = true;

  bool _soundFeedback = false;
  bool _vibrationFeedback = true;

  bool _darkMode = false;

  bool _loading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ============================================================
  // LOAD SETTINGS
  // ============================================================

  Future<void> _loadSettings() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _showBoundingBox =
          prefs.getBool(_showBoundingBoxKey) ?? true;

      _showConfidence =
          prefs.getBool(_showConfidenceKey) ?? true;

      _highAccuracy =
          prefs.getBool(_highAccuracyKey) ?? true;

      _autoStart =
          prefs.getBool(_autoStartKey) ?? false;

      _rememberCamera =
          prefs.getBool(_rememberCameraKey) ?? true;

      _soundFeedback =
          prefs.getBool(_soundFeedbackKey) ?? false;

      _vibrationFeedback =
          prefs.getBool(_vibrationFeedbackKey) ?? true;

      _darkMode =
          prefs.getBool(_darkModeKey) ?? false;

      _loading = false;
    });
  }

  // ============================================================
  // SAVE SETTING
  // ============================================================

  Future<void> _saveSetting(
      String key,
      bool value,
      ) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  // ============================================================
  // TOGGLE SETTING
  // ============================================================

  Future<void> _toggleSetting({
    required String key,
    required bool value,
    required void Function(bool) update,
  }) async {
    update(value);
    await _saveSetting(key, value);

    if (!mounted) return;

    setState(() {});
  }

  // ============================================================
  // RESET SETTINGS
  // ============================================================

  Future<void> _resetSettings() async {
    final bool? confirm =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Reset settings?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'All Object Vision settings will be '
                'restored to their default values.',
            style: TextStyle(
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF15966A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_showBoundingBoxKey);
    await prefs.remove(_showConfidenceKey);
    await prefs.remove(_highAccuracyKey);
    await prefs.remove(_autoStartKey);
    await prefs.remove(_rememberCameraKey);
    await prefs.remove(_soundFeedbackKey);
    await prefs.remove(_vibrationFeedbackKey);
    await prefs.remove(_darkModeKey);

    if (!mounted) return;

    setState(() {
      _showBoundingBox = true;
      _showConfidence = true;
      _highAccuracy = true;

      _autoStart = false;
      _rememberCamera = true;

      _soundFeedback = false;
      _vibrationFeedback = true;

      _darkMode = false;
    });

    _showMessage('Settings restored to default');
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
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
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7FAF8),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF15966A),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),

        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            35,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // ==================================================
              // SETTINGS HEADER CARD
              // ==================================================

              _settingsHeader(),

              const SizedBox(height: 28),

              // ==================================================
              // DETECTION
              // ==================================================

              _sectionTitle(
                icon: Icons.center_focus_strong_rounded,
                title: 'Detection',
              ),

              const SizedBox(height: 12),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.crop_free_rounded,
                    iconColor:
                    const Color(0xFF15966A),
                    title: 'Show bounding boxes',
                    subtitle:
                    'Display boxes around detected objects',
                    value: _showBoundingBox,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _showBoundingBoxKey,
                        value: value,
                        update: (v) {
                          _showBoundingBox = v;
                        },
                      );
                    },
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.analytics_outlined,
                    iconColor:
                    const Color(0xFF2878D8),
                    title: 'Show confidence',
                    subtitle:
                    'Display AI confidence percentage',
                    value: _showConfidence,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _showConfidenceKey,
                        value: value,
                        update: (v) {
                          _showConfidence = v;
                        },
                      );
                    },
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.high_quality_rounded,
                    iconColor:
                    const Color(0xFF8B5CF6),
                    title: 'High accuracy mode',
                    subtitle:
                    'Prioritize detection quality',
                    value: _highAccuracy,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _highAccuracyKey,
                        value: value,
                        update: (v) {
                          _highAccuracy = v;
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CAMERA
              // ==================================================

              _sectionTitle(
                icon: Icons.camera_alt_rounded,
                title: 'Camera',
              ),

              const SizedBox(height: 12),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.play_circle_outline_rounded,
                    iconColor:
                    const Color(0xFF15966A),
                    title: 'Auto start detection',
                    subtitle:
                    'Start scanning automatically',
                    value: _autoStart,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _autoStartKey,
                        value: value,
                        update: (v) {
                          _autoStart = v;
                        },
                      );
                    },
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.flip_camera_ios_outlined,
                    iconColor:
                    const Color(0xFFF59E0B),
                    title: 'Remember camera',
                    subtitle:
                    'Remember your last camera choice',
                    value: _rememberCamera,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _rememberCameraKey,
                        value: value,
                        update: (v) {
                          _rememberCamera = v;
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // FEEDBACK
              // ==================================================

              _sectionTitle(
                icon: Icons.notifications_none_rounded,
                title: 'Feedback',
              ),

              const SizedBox(height: 12),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.volume_up_outlined,
                    iconColor:
                    const Color(0xFFE05A47),
                    title: 'Sound feedback',
                    subtitle:
                    'Play a sound when an object is detected',
                    value: _soundFeedback,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _soundFeedbackKey,
                        value: value,
                        update: (v) {
                          _soundFeedback = v;
                        },
                      );
                    },
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.vibration_rounded,
                    iconColor:
                    const Color(0xFF6366F1),
                    title: 'Vibration feedback',
                    subtitle:
                    'Vibrate when detection changes',
                    value: _vibrationFeedback,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _vibrationFeedbackKey,
                        value: value,
                        update: (v) {
                          _vibrationFeedback = v;
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // APPEARANCE
              // ==================================================

              _sectionTitle(
                icon: Icons.palette_outlined,
                title: 'Appearance',
              ),

              const SizedBox(height: 12),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor:
                    const Color(0xFF374151),
                    title: 'Dark mode',
                    subtitle:
                    'Use a darker interface',
                    value: _darkMode,
                    onChanged: (value) {
                      _toggleSetting(
                        key: _darkModeKey,
                        value: value,
                        update: (v) {
                          _darkMode = v;
                        },
                      );

                      _showMessage(
                        value
                            ? 'Dark mode enabled'
                            : 'Dark mode disabled',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ==================================================
              // RESET
              // ==================================================

              _resetButton(),

              const SizedBox(height: 28),

              // ==================================================
              // ABOUT
              // ==================================================

              _aboutCard(),

              const SizedBox(height: 20),

              // ==================================================
              // VERSION
              // ==================================================

              const Center(
                child: Text(
                  'Object Vision • AI Object Detection',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  'Powered by Google ML Kit',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 10,
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
  // SETTINGS HEADER
  // ============================================================

  Widget _settingsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10271E),
            Color(0xFF174B38),
          ],
        ),

        borderRadius: BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10271E)
                .withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: Colors.greenAccent
                  .withOpacity(0.12),
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: Colors.greenAccent
                    .withOpacity(0.18),
              ),
            ),

            child: const Icon(
              Icons.tune_rounded,
              color: Colors.greenAccent,
              size: 29,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Object Vision Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Customize how Object Vision detects and displays objects.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
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
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: const Color(0xFF15966A),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: Colors.black.withOpacity(0.055),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.09),
              borderRadius:
              BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Switch.adaptive(
            value: value,
            activeColor:
            const Color(0xFF15966A),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 73,
        right: 16,
      ),
      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Colors.black.withOpacity(0.055),
      ),
    );
  }

  // ============================================================
  // RESET BUTTON
  // ============================================================

  Widget _resetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _resetSettings,

        icon: const Icon(
          Icons.restore_rounded,
          size: 19,
        ),

        label: const Text(
          'Reset All Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),

        style: OutlinedButton.styleFrom(
          foregroundColor:
          const Color(0xFFD14343),

          side: BorderSide(
            color: const Color(0xFFD14343)
                .withOpacity(0.25),
          ),

          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT CARD
  // ============================================================

  Widget _aboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFE9F8F1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(13),
            ),

            child: const Icon(
              Icons.remove_red_eye_outlined,
              color: Color(0xFF15966A),
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'About Object Vision',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10271E),
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Object Vision uses on-device AI '
                      'object detection to analyze objects '
                      'through your camera in real time.',
                  style: TextStyle(
                    color: Color(0xFF527064),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}