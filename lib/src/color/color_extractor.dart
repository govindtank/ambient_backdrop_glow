import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/ambient_glow_config.dart';

/// Ultra-fast color extraction utility that derives ambient palettes from images without UI jank.
class AmbientColorExtractor {
  /// Extracts an [AmbientColorPalette] from any Flutter [ImageProvider].
  static Future<AmbientColorPalette> extractFromProvider(
    ImageProvider provider, {
    int targetDimension = 24,
    ImageConfiguration configuration = ImageConfiguration.empty,
  }) async {
    try {
      final Completer<ui.Image> completer = Completer<ui.Image>();
      final ImageStream stream = provider.resolve(configuration);
      late ImageStreamListener listener;

      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          stream.removeListener(listener);
          if (!completer.isCompleted) {
            completer.complete(info.image);
          }
        },
        onError: (Object exception, StackTrace? stackTrace) {
          stream.removeListener(listener);
          if (!completer.isCompleted) {
            completer.completeError(exception, stackTrace);
          }
        },
      );

      stream.addListener(listener);
      final ui.Image image = await completer.future;
      final AmbientColorPalette palette =
          await extractFromImage(image, targetDimension: targetDimension);
      return palette;
    } catch (_) {
      return AmbientColorPalette.fallback();
    }
  }

  /// Extracts an [AmbientColorPalette] from a decoded [ui.Image].
  static Future<AmbientColorPalette> extractFromImage(
    ui.Image image, {
    int targetDimension = 24,
  }) async {
    try {
      // 1. Downscale onto an offscreen canvas to minimize pixel processing
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Rect srcRect =
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      final Rect dstRect = Rect.fromLTWH(
          0, 0, targetDimension.toDouble(), targetDimension.toDouble());

      final Paint paint = Paint()..filterQuality = FilterQuality.low;
      canvas.drawImageRect(image, srcRect, dstRect, paint);

      final ui.Picture picture = recorder.endRecording();
      final ui.Image downscaled =
          await picture.toImage(targetDimension, targetDimension);

      final ByteData? byteData =
          await downscaled.toByteData(format: ui.ImageByteFormat.rawRgba);
      downscaled.dispose();

      if (byteData == null) return AmbientColorPalette.fallback();

      final Uint8List bytes = byteData.buffer.asUint8List();
      return extractFromRgbaBytes(bytes, targetDimension, targetDimension);
    } catch (_) {
      return AmbientColorPalette.fallback();
    }
  }

  /// Extracts dominant, secondary, and accent colors from raw RGBA bytes.
  static AmbientColorPalette extractFromRgbaBytes(
      Uint8List bytes, int width, int height) {
    final Map<int, int> colorCounts = {};
    final int pixelCount = width * height;

    for (int i = 0; i < bytes.length; i += 4) {
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];
      final int a = bytes[i + 3];

      if (a < 128) continue; // Skip transparent

      // Quantize to 4-bit per channel (4096 color buckets)
      final int qr = (r >> 4) << 4;
      final int qg = (g >> 4) << 4;
      final int qb = (b >> 4) << 4;

      // Filter extreme black/white noise
      final double luma = (0.299 * qr + 0.587 * qg + 0.114 * qb) / 255.0;
      if (luma < 0.08 || luma > 0.95) continue;

      final int packed = (qr << 16) | (qg << 8) | qb;
      colorCounts[packed] = (colorCounts[packed] ?? 0) + 1;
    }

    if (colorCounts.isEmpty) {
      return AmbientColorPalette.fallback();
    }

    // Score colors based on vibrancy (saturation * count)
    final List<MapEntry<int, double>> scoredColors = [];

    for (final entry in colorCounts.entries) {
      final int packed = entry.key;
      final int r = (packed >> 16) & 0xFF;
      final int g = (packed >> 8) & 0xFF;
      final int b = packed & 0xFF;

      final hsv = HSVColor.fromColor(Color.fromARGB(255, r, g, b));
      // Prioritize high saturation and pleasant medium-high value
      final double saturationScore = hsv.saturation;
      final double frequencyScore = entry.value / pixelCount;
      final double score = (saturationScore * 0.7 + 0.3) * frequencyScore;

      scoredColors.add(MapEntry(packed, score));
    }

    scoredColors.sort((a, b) => b.value.compareTo(a.value));

    // Pick 3 distinct colors (with sufficient hue separation)
    final List<Color> picked = [];

    for (final entry in scoredColors) {
      final int packed = entry.key;
      final int r = (packed >> 16) & 0xFF;
      final int g = (packed >> 8) & 0xFF;
      final int b = packed & 0xFF;
      final Color candidate = Color.fromARGB(255, r, g, b);

      if (picked.isEmpty) {
        picked.add(candidate);
      } else {
        // Ensure hue difference >= 30 degrees
        final double candHue = HSVColor.fromColor(candidate).hue;
        bool isDistinct = true;
        for (final p in picked) {
          final double pHue = HSVColor.fromColor(p).hue;
          final double diff = (candHue - pHue).abs();
          final double circularDiff = diff > 180 ? 360 - diff : diff;
          if (circularDiff < 28.0) {
            isDistinct = false;
            break;
          }
        }
        if (isDistinct) {
          picked.add(candidate);
        }
      }

      if (picked.length >= 3) break;
    }

    return AmbientColorPalette.fromColors(picked);
  }
}
