import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/ambient_glow_config.dart';

/// High-performance [CustomPainter] simulating a multi-point fluid organic mesh gradient backdrop.
class MeshGlowPainter extends CustomPainter {
  /// The active color palette.
  final AmbientColorPalette palette;

  /// Visual styling parameters.
  final AmbientGlowStyle style;

  /// Animation phase angle in radians `[0, 2*pi)`.
  final double phase;

  /// Creates a [MeshGlowPainter].
  const MeshGlowPainter({
    required this.palette,
    this.style = const AmbientGlowStyle(),
    this.phase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final double w = size.width;
    final double h = size.height;
    final double t = phase;

    // 1. Draw base background fill
    final Paint bgPaint = Paint()..color = palette.background;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Harmonic motion trajectories for organic fluid mesh points
    final Offset p1 = Offset(
      w * (0.35 + 0.15 * math.cos(t)),
      h * (0.25 + 0.12 * math.sin(1.3 * t)),
    );

    final Offset p2 = Offset(
      w * (0.70 + 0.15 * math.sin(0.8 * t)),
      h * (0.65 + 0.15 * math.cos(t)),
    );

    final Offset p3 = Offset(
      w * (0.25 + 0.18 * math.cos(1.1 * t)),
      h * (0.75 + 0.12 * math.sin(0.9 * t)),
    );

    final Offset p4 = Offset(
      w * (0.65 + 0.12 * math.sin(1.4 * t)),
      h * (0.20 + 0.15 * math.cos(0.7 * t)),
    );

    final double baseRadius = math.max(w, h) * 0.55 * style.spread;

    // Draw mesh spots
    _drawGlowSpot(
        canvas, p1, baseRadius * 1.1, palette.primary, style.intensity);
    _drawGlowSpot(canvas, p2, baseRadius * 0.95, palette.secondary,
        style.intensity * 0.9);
    _drawGlowSpot(
        canvas, p3, baseRadius * 0.85, palette.accent, style.intensity * 0.85);
    _drawGlowSpot(canvas, p4, baseRadius * 0.75,
        palette.primary.withValues(alpha: 0.6), style.intensity * 0.7);

    // 3. Optional tint overlay
    if (style.tintColor != null && style.tintOpacity > 0) {
      final Paint tintPaint = Paint()
        ..color = style.tintColor!.withValues(alpha: style.tintOpacity);
      canvas.drawRect(Offset.zero & size, tintPaint);
    }
  }

  void _drawGlowSpot(Canvas canvas, Offset center, double radius, Color color,
      double intensity) {
    if (radius <= 0) return;

    final double effectiveAlpha = (color.a * intensity).clamp(0.0, 1.0);
    final Color centerColor = color.withValues(alpha: effectiveAlpha);
    final Color edgeColor = color.withValues(alpha: 0.0);

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [centerColor, edgeColor],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(MeshGlowPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.palette != palette ||
        oldDelegate.style != style;
  }
}
