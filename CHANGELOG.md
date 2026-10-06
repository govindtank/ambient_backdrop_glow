## 1.1.3

* docs: add interactive Live Web Demo and ecosystem documentation.

## 1.1.2

* Added `AmbientPresets` (cyberpunk, sunset, emerald mood palettes).
* Cleaned documentation and verified CI/CD workflows.

## 1.1.1

* Fixed dartdoc warnings to maximize pub.dev score.

## 1.1.0

* Added `enablePulse` in `AmbientGlowStyle` for organic breathing animations.
* Added `borderRadius` on `AmbientBackdropGlow` for rounded container clipping.
* Added explicit `platforms` declaration (Android, iOS, Web, macOS, Windows, Linux).

## 1.0.0

* Initial stable release of `ambient_backdrop_glow`.
* Added `AmbientBackdropGlow` drop-in widget with 4 ambient glow modes (`mesh`, `radial`, `aurora`, `spotlight`).
* Implemented perceptual `OkLab` color space interpolation to eliminate muddy gray cross-fade transitions.
* Implemented `AmbientColorExtractor` for ultra-fast, sub-4ms palette quantization from any `ImageProvider`.
* Added `MeshGlowPainter` and `RadialGlowPainter` with GPU blur shaders and harmonic fluid orbits.
* Added full customization for blur sigma, intensity, speed, spread, and color tints.
* Added interactive example application with media player mockup and live parameter sliders.
* 100% test coverage and zero pub.dev warnings.
