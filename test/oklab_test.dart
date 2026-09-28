import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambient_backdrop_glow/ambient_backdrop_glow.dart';

void main() {
  group('OkLab Perceptual Color Tests', () {
    test('Round-trip conversion sRGB -> OKLab -> sRGB', () {
      const List<Color> testColors = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.amber,
        Colors.purple,
        Color(0xFF0F172A),
        Colors.white,
      ];

      for (final color in testColors) {
        final lab = OkLab.colorToOkLab(color);
        expect(lab.length, 4);
        expect(lab[0].isNaN, isFalse);
        expect(lab[1].isNaN, isFalse);
        expect(lab[2].isNaN, isFalse);

        final recovered = OkLab.okLabToColor(lab[0], lab[1], lab[2], lab[3]);
        // Precision within 2/255
        expect((recovered.r - color.r).abs(), lessThan(0.02));
        expect((recovered.g - color.g).abs(), lessThan(0.02));
        expect((recovered.b - color.b).abs(), lessThan(0.02));
      }
    });

    test('OkLab.lerp maintains brightness and avoids muddy gray midpoint', () {
      const c1 = Color(0xFFFF0055); // Vibrant Pink
      const c2 = Color(0xFF00FFCC); // Vibrant Cyan

      final midOklab = OkLab.lerp(c1, c2, 0.5);

      final hsv = HSVColor.fromColor(midOklab);
      expect(hsv.saturation, greaterThan(0.25));
      expect(hsv.value, greaterThan(0.6));
      expect(midOklab.a, closeTo(1.0, 1e-4));
    });

    test('OkLab.lerp edge boundary conditions', () {
      const c1 = Colors.red;
      const c2 = Colors.blue;

      expect(OkLab.lerp(c1, c2, 0.0), equals(c1));
      expect(OkLab.lerp(c1, c2, 1.0), equals(c2));
    });
  });
}
