import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambient_backdrop_glow/ambient_backdrop_glow.dart';

void main() {
  group('AmbientColorExtractor Unit Tests', () {
    test(
        'extractFromRgbaBytes returns dominant vibrant colors from synthetic pixel buffer',
        () {
      const int w = 4;
      const int h = 4;
      final Uint8List bytes = Uint8List(w * h * 4);

      // Fill with vibrant orange (255, 120, 0, 255)
      for (int i = 0; i < bytes.length; i += 4) {
        bytes[i] = 255;
        bytes[i + 1] = 120;
        bytes[i + 2] = 0;
        bytes[i + 3] = 255;
      }

      final palette = AmbientColorExtractor.extractFromRgbaBytes(bytes, w, h);
      expect(palette.primary.r, greaterThan(0.8));
      expect(palette.primary.g, greaterThan(0.3));
      expect(palette.primary.b, lessThan(0.2));
    });

    test('extractFromRgbaBytes returns fallback on empty or black buffer', () {
      final Uint8List blackBytes = Uint8List(16 * 4); // All zeros
      final palette =
          AmbientColorExtractor.extractFromRgbaBytes(blackBytes, 4, 4);

      expect(palette, equals(AmbientColorPalette.fallback()));
    });
  });
}
