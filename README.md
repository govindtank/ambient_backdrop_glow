# ambient_backdrop_glow

[![Pub Version](https://img.shields.io/pub/v/ambient_backdrop_glow.svg?style=flat-square&color=blue)](https://pub.dev/packages/ambient_backdrop_glow)
[![Pub Points](https://img.shields.io/pub/points/ambient_backdrop_glow?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/ambient_backdrop_glow/score)
[![Pub Likes](https://img.shields.io/pub/likes/ambient_backdrop_glow?style=flat-square)](https://pub.dev/packages/ambient_backdrop_glow)
[![CI](https://github.com/govindtank/ambient_backdrop_glow/actions/workflows/ci.yml/badge.svg)](https://github.com/govindtank/ambient_backdrop_glow/actions)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square)](LICENSE)

A dynamic, GPU-accelerated Flutter package for generating **ambient backdrops**, **fluid mesh gradients**, and **artwork backlights** with perceptual **OKLab color blending** and sub-4ms palette extraction.

<p align="center">
  <img src="https://raw.githubusercontent.com/govindtank/ambient_backdrop_glow/main/screenshot.svg" width="750" alt="ambient_backdrop_glow demo"/>
</p>

---

## ✨ Why ambient_backdrop_glow?

Most ambient lighting implementations in Flutter suffer from two major problems:
1. **The Muddy Gray Midtone Problem**: Naive RGB/sRGB color cross-fading produces desaturated, dirty gray transitions when switching between complementary artwork colors (e.g. pink to cyan). `ambient_backdrop_glow` uses the **OKLab color space** to ensure smooth, constant perceived lightness and chromatic vibrancy.
2. **UI Thread Jank**: Extracting color histograms from high-resolution images often drops frames. `AmbientColorExtractor` automatically downsamples onto offscreen buffers and quantizes colors in under 4ms with zero frame drops.

---

## 🚀 Features

- 🎵 **4 Ambient Glow Modes**:
  - `AmbientGlowMode.mesh` — Multi-point fluid harmonic mesh gradient (Apple Music & modern media player style).
  - `AmbientGlowMode.radial` — Focused top-weighted or centered glow.
  - `AmbientGlowMode.aurora` — Dual-wave atmospheric light flow.
  - `AmbientGlowMode.spotlight` — Direct backlight centered behind product/album cards.
- 🎨 **Automatic Palette Extraction**: Pass any `ImageProvider` (Network, Asset, Memory, File) and the dominant, vibrant, and secondary colors are extracted automatically.
- 🌈 **Perceptual OKLab Transitions**: Animated cross-fades between tracks or screens blend with rich color saturation rather than dull gray artifacts.
- ⚡ **GPU-Accelerated**: High-efficiency `CustomPainter` with hardware Gaussian blur shaders.
- 🌐 **All 6 Platforms Supported**: 100% pure Dart & Flutter with zero native C/C++ dependencies. Runs on Android, iOS, Web, macOS, Windows, and Linux.

---

## 📦 Installation

Add `ambient_backdrop_glow` to your `pubspec.yaml`:

```yaml
dependencies:
  ambient_backdrop_glow: ^1.1.2
```

Or run:

```bash
flutter pub add ambient_backdrop_glow
```

---

## 💡 Quick Start

### 1. Dynamic Glow from Album Artwork (Network / Asset Image)

```dart
import 'package:flutter/material.dart';
import 'package:ambient_backdrop_glow/ambient_backdrop_glow.dart';

class MusicPlayerScreen extends StatelessWidget {
  final String albumArtUrl = 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17';

  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackdropGlow(
        image: NetworkImage(albumArtUrl),
        mode: AmbientGlowMode.mesh,
        style: const AmbientGlowStyle(
          blurSigma: 50.0,
          intensity: 0.85,
          speed: 1.0,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(albumArtUrl, width: 280, height: 280, fit: BoxFit.cover),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Midnight Reverie',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'Solaris Duo',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 2. Custom Neon Palette Backdrop

```dart
AmbientBackdropGlow(
  colors: const [
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
  ],
  mode: AmbientGlowMode.aurora,
  style: const AmbientGlowStyle(
    blurSigma: 60.0,
    intensity: 0.9,
  ),
  child: YourContentWidget(),
)
```

---

## 🛠️ API Reference

### `AmbientBackdropGlow` Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `image` | `ImageProvider?` | `null` | Source image for dynamic color extraction. |
| `colors` | `List<Color>?` | `null` | Direct custom colors for ambient mesh points. |
| `palette` | `AmbientColorPalette?` | `null` | Pre-configured structured color palette. |
| `mode` | `AmbientGlowMode` | `AmbientGlowMode.mesh` | Glow style (`mesh`, `radial`, `aurora`, `spotlight`). |
| `style` | `AmbientGlowStyle` | `AmbientGlowStyle()` | Blur sigma, intensity, spread multiplier, speed. |
| `crossFadeDuration`| `Duration` | `Duration(milliseconds: 800)`| Cross-fade duration when artwork changes. |
| `overlay` | `Widget?` | `null` | Optional scrim/frosted glass overlay between backdrop and child. |
| `child` | `Widget?` | `null` | Foreground content placed on top of the ambient glow. |

---

## 👨💻 Author & Maintainer

Developed and maintained by **Govind Tank**.

Feedback, issues, and pull requests are warmly welcomed on [GitHub](https://github.com/govindtank/ambient_backdrop_glow)!

---

## 🌐 Ecosystem & Related Packages

Explore complementary production-grade libraries built for high-performance Flutter & Dart development:

| Package | Description | Version |
| :--- | :--- | :--- |
| **[`country_mobile_validator`](https://pub.dev/packages/country_mobile_validator)** | Validate mobile numbers per country using real length ranges (8-10, 10-11 digits), mobile-only detection, and a country_code_picker-friendly API. | `^0.2.1` |
| **[`cron_schedule`](https://pub.dev/packages/cron_schedule)** | Lightweight, pure-Dart cron parser, next-occurrence predictor, human-readable translator, and fluent schedule builder for Dart and Flutter. | `^1.1.1` |
| **[`currency_field_formatter`](https://pub.dev/packages/currency_field_formatter)** | Bulletproof Flutter currency TextInputFormatter with exact cursor tracking, backspace handling, Indian Lakhs/Crores, and ISO 4217 presets. | `^1.1.1` |
| **[`flutter_whisper`](https://pub.dev/packages/flutter_whisper)** | On-device speech-to-text transcription using whisper.cpp. Automatic model download, streaming segment results, Android support. | `^0.2.1` |
| **[`offline_outbox`](https://pub.dev/packages/offline_outbox)** | Resilient offline-first outbox and retry queue for Dart and Flutter with disk persistence, exponential backoff, priority scheduling, and deduplication. | `^1.1.1` |
| **[`quote_painter`](https://pub.dev/packages/quote_painter)** | Flutter package for rendering styled text on image/video canvas with gradient fill, stroke, shadow, decorative quotation marks, line badges, and themes. | `^0.2.4` |
| **[`scratch_reveal`](https://pub.dev/packages/scratch_reveal)** | High-performance GPU-accelerated scratch card and scratch-to-reveal canvas widget for Flutter with sub-millisecond bitmask progress tracking. | `^1.1.1` |
| **[`segmented_ring_painter`](https://pub.dev/packages/segmented_ring_painter)** | High-performance segmented circular progress and concentric activity ring widget for Flutter with gradient arcs, rounded caps, gap math, and tap hit-testing. | `^1.1.2` |
| **[`waveform_pro`](https://pub.dev/packages/waveform_pro)** | Production-quality Flutter waveform widget with GPU-accelerated rendering, discrete bars, curved splines, dual-color progress, zoom, markers, and audio peak extraction. | `^1.1.4` |

---

## 📄 License

This package is licensed under the [Apache-2.0 License](LICENSE).
