import 'package:flutter/material.dart';

/// Rendering styles for ambient backdrop glowing.
enum AmbientGlowMode {
  /// Fluid multi-point organic mesh gradient (Apple Music & modern media player style).
  mesh,

  /// Focused top-weighted or center radial glow.
  radial,

  /// Dual-wave ambient aurora borealis flow.
  aurora,

  /// Direct spotlight behind central artwork card.
  spotlight,
}

/// Represents an extracted or custom color palette used to generate ambient backdrops.
class AmbientColorPalette {
  /// Primary dominant vibrant color.
  final Color primary;

  /// Secondary complementary color.
  final Color secondary;

  /// Vibrant accent highlight color.
  final Color accent;

  /// Background ambient fill color.
  final Color background;

  /// Whether the palette is predominantly dark or light.
  final bool isDark;

  /// Creates an [AmbientColorPalette].
  const AmbientColorPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    this.background = const Color(0xFF0F172A),
    this.isDark = true,
  });

  /// Creates a fallback default dark neon palette.
  factory AmbientColorPalette.fallback() {
    return const AmbientColorPalette(
      primary: Color(0xFF6366F1),
      secondary: Color(0xFFEC4899),
      accent: Color(0xFF06B6D4),
      background: Color(0xFF0F172A),
      isDark: true,
    );
  }

  /// Creates a palette from an ordered list of colors.
  factory AmbientColorPalette.fromColors(
    List<Color> colors, {
    Color background = const Color(0xFF0F172A),
    bool isDark = true,
  }) {
    if (colors.isEmpty) return AmbientColorPalette.fallback();

    final Color c1 = colors[0];
    final Color c2 = colors.length > 1 ? colors[1] : _adjustHue(c1, 30);
    final Color c3 = colors.length > 2 ? colors[2] : _adjustHue(c1, -30);

    return AmbientColorPalette(
      primary: c1,
      secondary: c2,
      accent: c3,
      background: background,
      isDark: isDark,
    );
  }

  static Color _adjustHue(Color color, double degrees) {
    final hsv = HSVColor.fromColor(color);
    final newHue = (hsv.hue + degrees) % 360.0;
    return hsv.withHue(newHue < 0 ? newHue + 360 : newHue).toColor();
  }

  /// Copies this palette with updated values.
  AmbientColorPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? background,
    bool? isDark,
  }) {
    return AmbientColorPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AmbientColorPalette &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.accent == accent &&
        other.background == background &&
        other.isDark == isDark;
  }

  @override
  int get hashCode =>
      Object.hash(primary, secondary, accent, background, isDark);
}

/// Visual customization settings for [AmbientBackdropGlow].
class AmbientGlowStyle {
  /// Gaussian blur sigma applied to the ambient background.
  final double blurSigma;

  /// Overall glow opacity and brightness multiplier in `[0.0, 1.0]`.
  final double intensity;

  /// Spread multiplier for radial and mesh light spots.
  final double spread;

  /// Fluid motion speed multiplier (1.0 = normal pacing, 0.0 = static).
  final double speed;

  /// Optional color tint applied on top of the ambient mesh.
  final Color? tintColor;

  /// Opacity of the tint layer in `[0.0, 1.0]`.
  final double tintOpacity;

  /// Whether to add subtle rhythmic breathing/pulsing animation.
  final bool enablePulse;

  /// Creates an [AmbientGlowStyle].
  const AmbientGlowStyle({
    this.blurSigma = 50.0,
    this.intensity = 0.85,
    this.spread = 1.1,
    this.speed = 1.0,
    this.tintColor,
    this.tintOpacity = 0.15,
    this.enablePulse = false,
  })  : assert(blurSigma >= 0, 'blurSigma must be non-negative'),
        assert(intensity >= 0 && intensity <= 1.0,
            'intensity must be in [0.0, 1.0]');

  /// Copies this style with updated values.
  AmbientGlowStyle copyWith({
    double? blurSigma,
    double? intensity,
    double? spread,
    double? speed,
    Color? tintColor,
    double? tintOpacity,
    bool? enablePulse,
  }) {
    return AmbientGlowStyle(
      blurSigma: blurSigma ?? this.blurSigma,
      intensity: intensity ?? this.intensity,
      spread: spread ?? this.spread,
      speed: speed ?? this.speed,
      tintColor: tintColor ?? this.tintColor,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      enablePulse: enablePulse ?? this.enablePulse,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AmbientGlowStyle &&
        other.blurSigma == blurSigma &&
        other.intensity == intensity &&
        other.spread == spread &&
        other.speed == speed &&
        other.tintColor == tintColor &&
        other.tintOpacity == tintOpacity &&
        other.enablePulse == enablePulse;
  }

  @override
  int get hashCode => Object.hash(
        blurSigma,
        intensity,
        spread,
        speed,
        tintColor,
        tintOpacity,
        enablePulse,
      );
}

/// Ready-to-use ambient backdrop palettes for popular media moods.
class AmbientPresets {
  /// Cyberpunk neon palette (Magenta + Cyan).
  static const AmbientColorPalette cyberpunk = AmbientColorPalette(
    primary: Color(0xFFFF007F),
    secondary: Color(0xFF00F0FF),
    accent: Color(0xFF7000FF),
    background: Color(0xFF0A0A12),
  );

  /// Sunset acoustic palette (Deep Orange + Amber).
  static const AmbientColorPalette sunset = AmbientColorPalette(
    primary: Color(0xFFFF5E36),
    secondary: Color(0xFFFFAE33),
    accent: Color(0xFFE02475),
    background: Color(0xFF140D0E),
  );

  /// Emerald forest ambient mood (Emerald + Mint).
  static const AmbientColorPalette emerald = AmbientColorPalette(
    primary: Color(0xFF10B981),
    secondary: Color(0xFF06B6D4),
    accent: Color(0xFF34D399),
    background: Color(0xFF061A14),
  );
}
