import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Accurate perceptual color blending using the OKLab color space.
///
/// Unlike naive sRGB interpolation (which produces muddy gray mid-tones),
/// OKLab preserves constant perceived lightness and chromatic vibrancy.
class OkLab {
  /// Converts an sRGB color component in `0, 1` to linear RGB.
  static double sRgbToLinear(double c) {
    if (c <= 0.04045) {
      return c / 12.92;
    }
    return math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Converts a linear RGB component in `0, 1` to sRGB.
  static double linearToSRgb(double c) {
    final double clamped = c.clamp(0.0, 1.0);
    if (clamped <= 0.0031308) {
      return 12.92 * clamped;
    }
    return 1.055 * math.pow(clamped, 1.0 / 2.4).toDouble() - 0.055;
  }

  /// Converts a [Color] to OKLab coordinates `[L, a, b, alpha]`.
  static List<double> colorToOkLab(Color color) {
    final double r = sRgbToLinear(color.r);
    final double g = sRgbToLinear(color.g);
    final double b = sRgbToLinear(color.b);

    final double l = math
        .pow(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b, 1.0 / 3.0)
        .toDouble();
    final double m = math
        .pow(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b, 1.0 / 3.0)
        .toDouble();
    final double s = math
        .pow(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b, 1.0 / 3.0)
        .toDouble();

    final double oklabL =
        0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s;
    final double oklabA =
        1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s;
    final double oklabB =
        0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s;

    return [oklabL, oklabA, oklabB, color.a];
  }

  /// Converts OKLab coordinates `[L, a, b, alpha]` back to a Flutter [Color].
  static Color okLabToColor(double oklabL, double oklabA, double oklabB,
      [double alpha = 1.0]) {
    final double l = oklabL + 0.3963377774 * oklabA + 0.2158037573 * oklabB;
    final double m = oklabL - 0.1055613458 * oklabA - 0.0638541728 * oklabB;
    final double s = oklabL - 0.0894841775 * oklabA - 1.2914855480 * oklabB;

    final double l3 = l * l * l;
    final double m3 = m * m * m;
    final double s3 = s * s * s;

    final double rLinear =
        4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    final double gLinear =
        -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    final double bLinear =
        -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    final double r = linearToSRgb(rLinear);
    final double g = linearToSRgb(gLinear);
    final double b = linearToSRgb(bLinear);

    return Color.from(
      alpha: alpha.clamp(0.0, 1.0),
      red: r.clamp(0.0, 1.0),
      green: g.clamp(0.0, 1.0),
      blue: b.clamp(0.0, 1.0),
    );
  }

  /// Perceptually interpolates between [colorA] and [colorB] at factor [t] in `[0.0, 1.0]`.
  static Color lerp(Color colorA, Color colorB, double t) {
    if (t <= 0.0) return colorA;
    if (t >= 1.0) return colorB;

    final List<double> labA = colorToOkLab(colorA);
    final List<double> labB = colorToOkLab(colorB);

    final double l = labA[0] + (labB[0] - labA[0]) * t;
    final double a = labA[1] + (labB[1] - labA[1]) * t;
    final double b = labA[2] + (labB[2] - labA[2]) * t;
    final double alpha = labA[3] + (labB[3] - labA[3]) * t;

    return okLabToColor(l, a, b, alpha);
  }
}
