import 'package:flutter/material.dart';
import 'package:ambient_backdrop_glow/ambient_backdrop_glow.dart';

void main() {
  runApp(const AmbientGlowDemoApp());
}

class AmbientGlowDemoApp extends StatelessWidget {
  const AmbientGlowDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ambient Backdrop Glow Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const AmbientDemoScreen(),
    );
  }
}

class AmbientDemoScreen extends StatefulWidget {
  const AmbientDemoScreen({super.key});

  @override
  State<AmbientDemoScreen> createState() => _AmbientDemoScreenState();
}

class _AmbientDemoScreenState extends State<AmbientDemoScreen> {
  AmbientGlowMode _mode = AmbientGlowMode.mesh;
  double _blurSigma = 45.0;
  double _intensity = 0.85;
  final double _speed = 1.0;
  int _selectedTrackIndex = 0;

  final List<Map<String, dynamic>> _tracks = [
    {
      'title': 'Midnight Horizon',
      'artist': 'Luna Waves',
      'colors': [
        const Color(0xFF6366F1),
        const Color(0xFFEC4899),
        const Color(0xFF06B6D4)
      ],
      'icon': Icons.nightlight_round,
      'gradient': [const Color(0xFF4F46E5), const Color(0xFFDB2777)],
    },
    {
      'title': 'Solar Flare',
      'artist': 'Helios Collective',
      'colors': [
        const Color(0xFFF59E0B),
        const Color(0xFFEF4444),
        const Color(0xFFF43F5E)
      ],
      'icon': Icons.wb_sunny_rounded,
      'gradient': [const Color(0xFFD97706), const Color(0xFFDC2626)],
    },
    {
      'title': 'Emerald Canopy',
      'artist': 'Verdant Echo',
      'colors': [
        const Color(0xFF10B981),
        const Color(0xFF06B6D4),
        const Color(0xFF84CC16)
      ],
      'icon': Icons.eco_rounded,
      'gradient': [const Color(0xFF059669), const Color(0xFF0891B2)],
    },
    {
      'title': 'Deep Abyss',
      'artist': 'Mariana Synth',
      'colors': [
        const Color(0xFF3B82F6),
        const Color(0xFF8B5CF6),
        const Color(0xFF06B6D4)
      ],
      'icon': Icons.water_drop_rounded,
      'gradient': [const Color(0xFF2563EB), const Color(0xFF7C3AED)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final track = _tracks[_selectedTrackIndex];
    final List<Color> trackColors = track['colors'] as List<Color>;
    final List<Color> cardGradient = track['gradient'] as List<Color>;

    return Scaffold(
      body: AmbientBackdropGlow(
        colors: trackColors,
        mode: _mode,
        style: AmbientGlowStyle(
          blurSigma: _blurSigma,
          intensity: _intensity,
          speed: _speed,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ambient_backdrop_glow',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        _mode.name.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // Player Card Preview
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 340),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF1E293B).withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(28.0),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Album Art Mockup
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: cardGradient,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardGradient[0]
                                          .withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    track['icon'] as IconData,
                                    size: 72,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Song Metadata
                            Text(
                              track['title'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              track['artist'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Playback controls mockup
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.skip_previous_rounded,
                                      size: 28),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTrackIndex =
                                          (_selectedTrackIndex -
                                                  1 +
                                                  _tracks.length) %
                                              _tracks.length;
                                    });
                                  },
                                ),
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_next_rounded,
                                      size: 28),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTrackIndex =
                                          (_selectedTrackIndex + 1) %
                                              _tracks.length;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Control Panel
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.9),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24.0)),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mode Selector Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AmbientGlowMode.values.map((m) {
                          final isSelected = _mode == m;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(m.name.toUpperCase()),
                              selected: isSelected,
                              selectedColor: const Color(0xFF6366F1),
                              onSelected: (_) => setState(() => _mode = m),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sliders
                    Row(
                      children: [
                        const Text('Blur',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                        Expanded(
                          child: Slider(
                            value: _blurSigma,
                            min: 0,
                            max: 90,
                            onChanged: (v) => setState(() => _blurSigma = v),
                          ),
                        ),
                        Text('${_blurSigma.toInt()}px',
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Glow',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                        Expanded(
                          child: Slider(
                            value: _intensity,
                            min: 0.1,
                            max: 1.0,
                            onChanged: (v) => setState(() => _intensity = v),
                          ),
                        ),
                        Text('${(_intensity * 100).toInt()}%',
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
