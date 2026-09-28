import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/ambient_glow_config.dart';

/// [CustomPainter] that renders focused radial, aurora wave, and spotlight ambient glows.
class RadialGlowPainter extends CustomPainter {
  /// The active color palette.
  final AmbientColorPalette palette;

  /// Visual styling parameters.
  final AmbientGlowStyle style;

  /// Selected ambient mode.
  final AmbientGlowMode mode;

  /// Animation phase in radians.
  final double phase;

  /// Creates a [RadialGlowPainter].
  const RadialGlowPainter({
    required this.palette,
    this.style = const AmbientGlowStyle(),
    this.mode = AmbientGlowMode.radial,
    this.phase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Base background
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.background);

    switch (mode) {
      case AmbientGlowMode.radial:
        _paintRadial(canvas, size);
        break;
      case AmbientGlowMode.spotlight:
        _paintSpotlight(canvas, size);
        break;
      case AmbientGlowMode.aurora:
        _paintAurora(canvas, size);
        break;
      case AmbientGlowMode.mesh:
        break;
    }

    // Optional tint
    if (style.tintColor != null && style.tintOpacity > 0) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = style.tintColor!.withValues(alpha: style.tintOpacity),
      );
    }
  }

  void _paintRadial(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.4);
    final double radius =
        math.max(size.width, size.height) * 0.6 * style.spread;

    final Paint paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.2),
        radius: 0.8 * style.spread,
        colors: [
          palette.primary.withValues(
              alpha: (palette.primary.a * style.intensity).clamp(0.0, 1.0)),
          palette.secondary.withValues(
              alpha: (palette.secondary.a * style.intensity * 0.6)
                  .clamp(0.0, 1.0)),
          palette.background.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  void _paintSpotlight(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius =
        math.min(size.width, size.height) * 0.45 * style.spread;

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.accent.withValues(
              alpha: (palette.accent.a * style.intensity).clamp(0.0, 1.0)),
          palette.primary.withValues(
              alpha:
                  (palette.primary.a * style.intensity * 0.5).clamp(0.0, 1.0)),
          palette.background.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  void _paintAurora(Canvas canvas, Size size) {
    final double t = phase;
    final double w = size.width;
    final double h = size.height;

    // Top wave
    final Rect rectTop = Rect.fromLTWH(
      -w * 0.2 + math.sin(t) * 30,
      -h * 0.2,
      w * 1.4,
      h * 0.8,
    );
    final Paint waveTop = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          palette.primary.withValues(
              alpha: (palette.primary.a * style.intensity).clamp(0.0, 1.0)),
          palette.accent.withValues(
              alpha:
                  (palette.accent.a * style.intensity * 0.7).clamp(0.0, 1.0)),
          palette.background.withValues(alpha: 0.0),
        ],
      ).createShader(rectTop);

    canvas.drawOval(rectTop, waveTop);

    // Bottom wave
    final Rect rectBottom = Rect.fromLTWH(
      -w * 0.1 + math.cos(t * 0.8) * 30,
      h * 0.4,
      w * 1.3,
      h * 0.8,
    );
    final Paint waveBottom = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          palette.secondary.withValues(
              alpha: (palette.secondary.a * style.intensity * 0.8)
                  .clamp(0.0, 1.0)),
          palette.background.withValues(alpha: 0.0),
        ],
      ).createShader(rectBottom);

    canvas.drawOval(rectBottom, waveBottom);
  }

  @override
  bool shouldRepaint(RadialGlowPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.palette != palette ||
        oldDelegate.style != style ||
        oldDelegate.mode != mode;
  }
}
